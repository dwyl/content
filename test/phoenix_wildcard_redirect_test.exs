defmodule PhoenixWildcardRidrectTest do
  @moduledoc """
  If you want to understand how this test is set up, read: https://git.io/JfrZq
  That is where I discovered that I could in-line an entire Phoenix App
  in a single test file. 
  """
  use ExUnit.Case, async: true
  use Plug.Test

  # Borrowed from: https://git.io/JfrZt
  def call(router, verb, path, params \\ nil, script_name \\ []) do
    verb
    |> conn(path, params)
    |> Plug.Conn.fetch_query_params
    |> Map.put(:script_name, script_name)
    |> router.call(router.init([]))
  end

  defmodule Controller do
    use Phoenix.Controller

    def index(conn, _params), do: text(conn, "index")
    
    def hello(conn, _params) do 
      json(conn, %{"hello" => "world"})
    end

    def wildcard_redirect(conn, params) do
      try do
        Content.wildcard_redirect(conn, params, PhoenixWildcardRidrectTest.Router)
      rescue
        UndefinedFunctionError -> 
          conn
          |> Plug.Conn.send_resp(404, "not found")
          |> Plug.Conn.halt()
      end
    end
  end

  defmodule Router do
    use Phoenix.Router

    pipeline :any do
      plug :accepts, ~w(html json)
      plug Content, %{html_plugs: []}
    end

    scope "/" do
      pipe_through :any

      get "/index", Controller, :index
      get "/hello", Controller, :hello
      get "/*pokemon", Controller, :wildcard_redirect

    end
  end  

  test "routes to :index (test that our micro Phoenix works!)" do
    conn = call(Router, :get, "index")
    assert conn.status == 200
    assert conn.resp_body == "index"
  end

  test "test redirect_json/3 invokes :index for index.json" do
    data = %{"hello" => "world"}
    conn = call(Router, :get, "/hello.json") # should get caught by pokemon

    assert conn.status == 200
    {:ok, json} = Jason.decode(conn.resp_body)
    assert json == data
  end

  test "test redirect_json/3 should return 404 if no route" do
    conn = call(Router, :get, "/notfound.json")
    # assert conn.status == 404
    assert conn.resp_body == "not found"
  end

end
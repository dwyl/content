defmodule ContentTest do
  use ExUnit.Case
  use Plug.Test
  # @opts AuthPlug.init(%{auth_url: "https://dwylauth.herokuapp.com"})


  def dummy(conn, _params) do
    IO.inspect(conn.halted, label: "conn.halted")
  end


  test "Plug init function doesn't change params" do
    assert Content.init(%{}) == %{}
    IO.inspect("hello")
  end


  test "invoke call/2 with accept=json" do
    conn =
      conn(:get, "/admin")
      |> put_req_header("accept", "html")
      |> Content.call(%{ plugs: [&dummy/2] })

    # IO.inspect(conn, label: "conn:21")
    # redirect when auth fails
    # assert conn.status == 302
  end

  test "greets the world" do
    assert Content.hello() == :world
  end
end

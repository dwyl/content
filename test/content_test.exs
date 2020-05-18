defmodule ContentTest do
  use ExUnit.Case
  use Plug.Test
  # @opts AuthPlug.init(%{auth_url: "https://dwylauth.herokuapp.com"})


  def dummy(conn, _params) do
    IO.inspect(conn.halted, label: "conn.halted")
    # IO.inspect(conn, label: "conn:9")
    conn
    |> assign(:dummy, "hello")
  end

  def assign_accept_header(conn, _params) do
    # IO.inspect(conn.req_headers, label: "conn.req_headers")
    # IO.inspect(conn, label: "conn:16")
    conn
    |> assign(:accept, Content.get_accept_header(conn))
    # |> IO.inspect(label: "conn:19")
  end


  test "Plug init function doesn't change params" do
    assert Content.init(%{}) == %{}
    IO.inspect("hello")
  end


  test "invoke call/2 with accept=html" do
    conn =
      conn(:get, "/admin")
      |> put_req_header("accept", "html")
      |> Content.call(%{ html_plugs: [&dummy/2, &assign_accept_header/2] })

    assert conn.assigns == %{accept: "html", dummy: "hello"}
    assert conn.status == nil
  end

  test "greets the world" do
    assert Content.hello() == :world
  end
end

defmodule ContentTest do
  use ExUnit.Case
  use Plug.Test
  # @opts AuthPlug.init(%{auth_url: "https://dwylauth.herokuapp.com"})


  def dummy(conn, _params) do
    IO.inspect(conn.halted, label: "conn.halted")
  end

  def log_headers(conn, _params) do
    IO.inspect(conn.req_headers, label: "conn.req_headers")
  end


  test "Plug init function doesn't change params" do
    assert Content.init(%{}) == %{}
    IO.inspect("hello")
  end


  test "invoke call/2 with accept=html" do
    conn =
      conn(:get, "/admin")
      |> put_req_header("accept", "html")
      |> Content.call(%{ html_plugs: [&dummy/2, &log_headers/2] })

    assert conn.status == nil
  end

  test "greets the world" do
    assert Content.hello() == :world
  end
end

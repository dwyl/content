defmodule ContentTest do
  use ExUnit.Case
  use Plug.Test
  # @opts AuthPlug.init(%{auth_url: "https://dwylauth.herokuapp.com"})


  def dummy(conn, _params) do
    # IO.inspect(conn.halted, label: "conn.halted")
    # IO.inspect(conn, label: "conn:9")
    conn
    |> assign(:dummy, "hello")
  end

  # another dummy function for testing call/2 html_plugs
  def assign_accept_header(conn, _params) do
    # IO.inspect(conn.req_headers, label: "conn.req_headers")
    # IO.inspect(conn, label: "conn:16")
    conn
    |> assign(:accept, Content.get_accept_header(conn))
    # |> IO.inspect(label: "conn:19")
  end


  test "Plug init function doesn't change params" do
    assert Content.init(%{}) == %{}
  end

  test "invoke call/2 with accept=json" do
    conn =
      conn(:get, "/")
      |> put_req_header("accept", "application/json")
      |> Content.call(%{})

    # not much else we can assert here, it just returns the conn unmodified.
    IO.inspect(conn, label: "conn")
    assert conn.status == nil
  end

  test "invoke call/2 with accept=html" do
    conn =
      conn(:get, "/")
      |> put_req_header("accept", "html")
      |> Content.call(%{ html_plugs: [&dummy/2, &assign_accept_header/2] })

    assert conn.assigns == %{accept: "html", dummy: "hello"}
    assert conn.status == nil
  end

  test "invoke call/2 with accept=html with non-function html_plugs" do
    conn =
      conn(:get, "/")
      |> put_req_header("accept", "html")
      |> Content.call(%{ html_plugs:
        [&dummy/2, &assign_accept_header/2, "this is ignored"] })

    assert conn.assigns == %{accept: "html", dummy: "hello"}
    assert conn.status == nil
  end

  # mock Phoenix json function:
  def render_json(conn, data) do
    {:ok, json} = Jason.encode(data)
    Map.put(conn, :resp_body, json)
  end

  def render_html(conn, template, data) do
    str = "<html> #{template} " <> Kernel.inspect(data) <> "</html>"
    Map.put(conn, :resp_body, str)
    # conn
  end

  test "reply/5 should render json if accept header is json" do
    data = %{"hello" => "world"}
    conn =
      conn(:get, "/")
      |> put_req_header("accept", "application/json")
      |> Content.reply(&render_html/3, "my_template", &render_json/2, data)
      # |> IO.inspect(label: "conn:54")

    {:ok, json} = Jason.decode(conn.resp_body)
    assert json == data
  end

  test "reply/5 should render HTML if accept header is html" do
    conn =
      conn(:get, "/")
      |> put_req_header("accept", "text/html")
      |> Content.reply(&render_html/3, "my_template", &render_json/2, "data")

    assert conn.resp_body == "<html> my_template [data: \"data\"]</html>"
  end

end

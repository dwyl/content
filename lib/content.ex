defmodule Content do
  @moduledoc """
  `Content` handles Content Negotiation in any Elixir/Phoenix App.
  Please see: github.com/dwyl/content for detail.
  """

  @doc """
  `init/1` initialises the options passed in and makes them
  available in the lifecycle of the `call/2` invocation (below).
  When invoking the `Content` plug in a Phoenix router pipeline,
  we pass in a Map containing a key `html_plugs` with a list of
  plugs that need to be run when the accept header is "html".
  See implimentation docs for more detail/clarity.
  """
  def init(options) do
    # return options unmodified
    options
  end

  @doc """
  `call/2` is invoked to handle each HTTP request which `Content` inspects.
  If the accept header is "html", execute the `html_plugs` for that request.
  If the accept header contains "json" return the `conn` unmodified.
  """
  def call(conn, options) do
    if get_accept_header(conn) =~ "json" do
      #  for json requests return the conn unmodified:
      #  if we need options.json_plugs in the future, we can add it.
      conn
    else
      #  if accept header not "json" then assume "html" (the default)
      # invoke each function in the list of html_plugs
      # and pass the conn as accumulator through each iteration
      # return the conn with all html_plugs applied to it.
      # see: https://hexdocs.pm/elixir/List.html#foldl/3
      List.foldl(options.html_plugs, conn, fn f, conn ->
        if is_function(f) do
          f.(conn, [])
        else
          conn
        end
      end)
    end
  end

  @doc """
  `get_accept_header/1` gets the "accept" header from req_headers.
  Defaults to "text/html" if no header is set.
  """
  def get_accept_header(conn) do
    case List.keyfind(conn.req_headers, "accept", 0) do
      {"accept", accept} ->
        accept

      nil ->
        "text/html"
    end
  end

  @doc """
  `reply/5` gets the "accept" header from req_headers.
  Defaults to "text/html" if no header is set.
  The `Content.reply/5` accepts the following 5 argument:
  1. `conn` - the `Plug.Conn` where we get the `req_headers` from.
  2. `render/3` - the `Phoenix.Controller.render/3` function,
    or your own implementation of a render function that
    takes `conn`, `template` and `data` as it's 3 params.
  3. `template` - the `.html` template to be rendered
    if the `accept` header matches `"html"`; e.g: `"index.html"`
  4. `json/2` - the `Phoenix.Controller.json/2` function
    that renders `json` data.
    Or your own implementation that accepts the two params:
    `conn` and `data` corresponding to the `Plug.Conn`
    and the `json` data you want to return.
  5. `data` - the data we want to render as `HTML` or `JSON`.
  """
  def reply(conn, render, template, json, data) do
    if get_accept_header(conn) =~ "json" do
      json.(conn, data)
    else
      render.(conn, template, data: data)
    end
  end
end

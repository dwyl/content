defmodule Content do
  @moduledoc """
  `Content` handles Content Negotation in any Elixir/Phoenix App.
  Please see: github.com/dwyl/content for detail.
  """
  # https://hexdocs.pm/plug/readme.html#the-plug-conn-struct
  # import Plug.Conn
  # https://hexdocs.pm/logger/Logger.html
  # require Logger

  @doc """
  `init/1` initialises the options passed in and makes them
  available in the lifecycle of the `call/2` invocation (below).
  We pass in the `auth_url` key/value with the URL of the Auth service
  to redirect to if session is invalid/expired.
  """
  def init(options) do
    # return options unmodified
    options
    |> IO.inspect(label: "options:20")
  end

  @doc """
  `call/2` is invoked to handle each HTTP request which `Content` inspects.
  """
  def call(conn, options) do
    if get_accept_header(conn) =~ "json" do
      # for json requests return the conn unmodified:
      conn
    else
      # if accept header not "json" then assume "html" (the default)
      # invoke each function in the list of html_plugs
      # and pass the conn as accumulator through each iteration
      # return the conn with all html_plugs applied to it.
      # see: https://hexdocs.pm/elixir/List.html#foldl/3
      List.foldl(options.html_plugs, conn, fn f, conn ->
        if (is_function(f)) do
          f.(conn, [])
        else
          conn
        end
      end)
    end
  end

  @doc """
  `get_accept_header/2` gets the "accept" header from req_headers.
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
  """
  def reply(conn, render, template, json, data) do
    if get_accept_header(conn) =~ "json" do
      json.(conn, data)
    else
      render.(conn, template, data: data)
    end
  end
end

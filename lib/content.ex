defmodule Content do
  @moduledoc """
  `Content` handles Content Negotation in any Elixir/Phoenix App.
  Please see: github.com/dwyl/content for detail.
  """
  # https://hexdocs.pm/plug/readme.html#the-plug-conn-struct
  import Plug.Conn
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
  end

  @doc """
  `call/2` is invoked to handle each HTTP request which `Content` inspects.
  """
  def call(conn, options) do

    conn
  end

  def hello do
    :world
  end
end

defmodule ContentTest do
  use ExUnit.Case
  doctest Content

  test "greets the world" do
    assert Content.hello() == :world
  end
end

defmodule Content.MixProject do
  use Mix.Project

  def project do
    [
      app: :content,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Plug helper functions: github.com/elixir-plug/plug
      {:plug, "~> 1.10"},

      # Track coverage: github.com/parroty/excoveralls
      {:excoveralls, "~> 0.12.3", only: :test},

      # See: github.com/dwyl/auth_plug_example
      # {:plug_cowboy, "~> 2.1", only: [:dev, :test]},

      # For publishing Hex.docs:
      {:ex_doc, "~> 0.21.3", only: :dev}
    ]
  end
end

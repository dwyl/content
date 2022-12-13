defmodule Content.MixProject do
  use Mix.Project

  def project do
    [
      app: :content,
      version: "1.3.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Content Negotation lets you render HTML and JSON in the same route.",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp package() do
    [
      files: ~w(lib/content.ex LICENSE mix.exs README.md),
      name: "content",
      licenses: ["GNU GPL v2.0"],
      maintainers: ["dwyl"],
      links: %{"GitHub" => "https://github.com/dwyl/content"}
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
      {:plug, "~> 1.10", only: [:dev, :test]},

      # Testing Wildcard Route Handler in a Phoenix App:
      {:jason, "~> 1.4", only: [:dev, :test]},
      {:phoenix, "~> 1.6.7", only: [:dev, :test]},

      # Track coverage: github.com/parroty/excoveralls
      {:excoveralls, "~> 0.15", only: :test},

      # For publishing Hex.docs:
      {:ex_doc, "~> 0.29", only: :dev}
    ]
  end
end

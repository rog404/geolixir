defmodule Geolixir.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :geolixir,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A simple and efficient geolocation library for Elixir applications.",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: "Geolixir",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rog404/geolixir"},
      maintainers: ["Rogerio Bordignon"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.10", only: :test}
    ]
  end
end

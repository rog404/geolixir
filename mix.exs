defmodule Geolixir.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :geolixir,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A simple and efficient geolocation library for Elixir applications.",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs()
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
      name: "geolixir",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/rog404/geolixir"},
      maintainers: ["Rogerio Bordignon"]
    ]
  end

  defp docs do
    [
      # The main module for landing page
      main: "Geolixir",
      source_url: "https://github.com/rog404/geolixir",
      # Optional: link to tagged version
      source_ref: "v#{@version}",
      extras: ["README.md", "LICENSE"],
      groups_for_modules: [
        Providers: ~r/Geolixir\.Providers\.\w+$/,
        Structs: ~r/Geolixir\.(Bounds|Coords|Location|Result)$/,
        Internals: [Geolixir.HttpClient, Geolixir.Provider, Geolixir.Providers.Base]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      # Explicitly add Jason if not already present, needed by HTTPoison/ExDoc
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mimic, "~> 1.10", only: :test}
    ]
  end
end

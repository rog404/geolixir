# Geolixir

A simple and efficient geolocation library for Elixir applications. Geolixir provides an easy way to get geographical information from addresses or coordinates.

## Features

- Geocoding
- Reverse geocoding (coordinates to location)
- Multiple provider support (configurable)
- Lightweight with minimal dependencies

## Installation

Add `geolixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:geolixir, "~> 0.1.0"}
  ]
```

## Roadmap

Here are the planned next steps for Geolixir:

- Implement tests
- Implement batch operations with `list_geocode` and `list_reverse_geocode` functions
- Add more providers:
  - Google Maps API
  - Here Maps
  - Mapbox
  - TomTom
  - MapQuest
- Improve error handling and reporting

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/geolixir>.


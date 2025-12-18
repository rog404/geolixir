# Geolixir

Welcome to Geolixir! This library makes it simple to work with geocoding in your Elixir projects. Easily convert addresses to coordinates (geocoding) and coordinates back to addresses (reverse geocoding).

## ✨ Features

*   **Geocoding:** Find latitude and longitude from an address.
*   **Reverse Geocoding:** Find address details from latitude and longitude.
*   **Multiple Providers:** Supports various geocoding services (OpenStreetMap, Geoapify, Google Maps, Geocoding, PositionStack). You can choose your preferred provider or stick with the default.
*   **Simple Interface:** Easy-to-use functions for common tasks.

## 🚀 Installation

Add `geolixir` to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:geolixir, "~> 0.1.4"}
  ]
end
```

Then, run `mix deps.get` in your terminal.

## 💡 Usage

Here's how you can use Geolixir:

### Geocoding (Address to Coordinates)

```elixir
# Using the default provider (OpenStreetMap)
iex> Geolixir.geocode("1600 Amphitheatre Parkway, Mountain View, CA")
{:ok, %Geolixir.Result{
  coordinates: %Geolixir.Coords{lat: 37.4224764, lon: -122.0842499},
  location: %Geolixir.Location{...},
  bounds: %Geolixir.Bounds{...},
  metadata: %{}
}}

# Using a specific provider (e.g., Geoapify, requires API key)
iex> Geolixir.geocode("Eiffel Tower, Paris", provider: :geoapify, api_key: "YOUR_GEOAPIFY_KEY")
{:ok, %Geolixir.Result{...}}
```

### Reverse Geocoding (Coordinates to Address)

```elixir
# Using the default provider
iex> Geolixir.reverse_geocode(48.8584, 2.2945)
{:ok, %Geolixir.Result{
  location: %Geolixir.Location{formatted_address: "Tour Eiffel, 5, Avenue Anatole France, ...", ...},
  ...
}}

# Using a specific provider (e.g., PositionStack, requires API key)
iex> Geolixir.reverse_geocode(40.7128, -74.0060, provider: :position_stack, api_key: "YOUR_POSITIONSTACK_KEY")
{:ok, %Geolixir.Result{...}}

# Handling errors
iex> Geolixir.reverse_geocode(999.0, 999.0)
{:error, _provider_error_map} # Example error
```

**Note:** Some providers require an API key. Pass it using the `api_key: "your_key"` option. Check the specific provider module documentation for details.

## 🛣️ Roadmap

*   Create documentation on HexDocs
*   Implement batch operations (`list_geocode`, `list_reverse_geocode`).
*   Add support for more geocoding providers.
*   Enhance error handling.

## 📚 Documentation

Full documentation can be generated using ExDoc and published on [HexDocs](https://hexdocs.pm/geolixir).


## 📝 License

Licensed under the [MIT License](./LICENSE).

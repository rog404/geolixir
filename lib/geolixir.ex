defmodule Geolixir do
  @moduledoc """
  Geolixir provides a simple and unified interface for geocoding and reverse
  geocoding using various external providers.

  It allows converting addresses to geographical coordinates (latitude and longitude)
  and vice-versa.

  ## Usage

  Add Geolixir to your `mix.exs` dependencies:

  ```elixir
  def deps do
    [
      {:geolixir, "~> 0.1.0"}
    ]
  end
  ```

  Then fetch the dependencies:

  ```bash
  mix deps.get
  ```

  ### Geocoding

  ```elixir
  # Using the default provider (OpenStreetMaps)
  iex> Geolixir.geocode("1600 Amphitheatre Parkway, Mountain View, CA")
  {:ok, %Geolixir.Result{
    coordinates: %Geolixir.Coords{lat: 37.4224764, lon: -122.0842499},
    location: %Geolixir.Location{...},
    ...
  }}

  # Using a specific provider (e.g., Geoapify, requires API key)
  iex> Geolixir.geocode("Eiffel Tower, Paris", provider: :geoapify, api_key: "YOUR_GEOAPIFY_KEY")
  {:ok, %Geolixir.Result{...}}
  ```

  ### Reverse Geocoding

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
  ```

  See `geocode/2` and `reverse_geocode/3` for more details and options.
  """

  alias Geolixir.Result

  @provider_modules %{
    open_street_maps: Geolixir.Providers.OpenStreetMaps,
    geoapify: Geolixir.Providers.Geoapify,
    geocoding: Geolixir.Providers.Geocoding,
    position_stack: Geolixir.Providers.PositionStack
  }

  @default_provider :open_street_maps

  @doc """
  Geocodes a given address string into geographical coordinates.

  It uses the configured default provider unless a specific `:provider` is
  specified in the options. Some providers may require an `:api_key`.

  ## Parameters
    - `address`: The address string to geocode (e.g., "1600 Amphitheatre Parkway, Mountain View, CA").
    - `opts`: A keyword list of options.
      - `:provider`: (Optional) The atom representing the provider module to use (e.g., `:geoapify`, `:open_street_maps`). Defaults to `#{inspect(@default_provider)}`.
      - `:api_key`: (Optional) The API key required by some providers.
      - Other options specific to the chosen provider may also be passed.

  ## Returns
    - `{:ok, %Result{}}`: On success, returns a tuple with `:ok` and a `Geolixir.Result` struct containing coordinates, location details, bounds, and metadata.
    - `{:error, reason}`: On failure, returns a tuple with `:error` and the reason (e.g., `:no_results_found`, `:invalid_api_key`, HTTP error details).

  ## Examples

      iex> Geolixir.geocode("Eiffel Tower, Paris")
      {:ok, %Geolixir.Result{coordinates: %Geolixir.Coords{lat: 48.858..., lon: 2.294...}, ...}}

      iex> Geolixir.geocode("NonExistentPlace12345", provider: :open_street_maps)
      {:error, :no_results_found} # Example error, actual error may vary

      iex> Geolixir.geocode("Statue of Liberty", provider: :geoapify, api_key: "YOUR_KEY")
      {:ok, %Geolixir.Result{...}} # Requires a valid Geoapify key

      iex> Geolixir.geocode("Some Address", provider: :unknown_provider)
      ** (ArgumentError) Unknown provider: unknown_provider. Available providers: [...]
  """
  @spec geocode(String.t(), keyword()) :: {:ok, Result.t()} | {:error, atom() | map()}
  def geocode(address, opts \\ []) do
    provider = resolve_provider(opts[:provider] || @default_provider)
    provider.geocode(%{address: address}, opts)
  end

  @doc """
  Reverse geocodes geographical coordinates (latitude and longitude) into an address.

  It uses the configured default provider unless a specific `:provider` is
  specified in the options. Some providers may require an `:api_key`.

  ## Parameters
    - `lat`: The latitude.
    - `lon`: The longitude.
    - `opts`: A keyword list of options.
      - `:provider`: (Optional) The atom representing the provider module to use (e.g., `:geoapify`, `:open_street_maps`). Defaults to `#{inspect(@default_provider)}`.
      - `:api_key`: (Optional) The API key required by some providers.
      - Other options specific to the chosen provider may also be passed.

  ## Returns
    - `{:ok, %Result{}}`: On success, returns a tuple with `:ok` and a `Geolixir.Result` struct containing location details, coordinates, bounds, and metadata.
    - `{:error, reason}`: On failure, returns a tuple with `:error` and the reason (e.g., `:no_results_found`, `:invalid_coordinates`, HTTP error details).

  ## Examples

      iex> Geolixir.reverse_geocode(40.7128, -74.0060) # New York City Hall approx.
      {:ok, %Geolixir.Result{location: %Geolixir.Location{formatted_address: "City Hall Park, ...", ...}, ...}}

      iex> Geolixir.reverse_geocode(999.0, 999.0)
      {:error, :invalid_coordinates} # Example error, actual error may vary

      iex> Geolixir.reverse_geocode(51.5074, -0.1278, provider: :position_stack, api_key: "YOUR_KEY")
      {:ok, %Geolixir.Result{...}} # Requires a valid PositionStack key
  """
  @spec reverse_geocode(lat :: float(), lon :: float(), opts :: keyword()) ::
          {:ok, Result.t()} | {:error, atom() | map()}
  def reverse_geocode(lat, lon, opts \\ []) do
    provider = resolve_provider(opts[:provider] || @default_provider)
    provider.reverse_geocode(%{lat: lat, lon: lon}, opts)
  end

  # Private function to resolve the provider
  defp resolve_provider(provider_key) when is_atom(provider_key) do
    case @provider_modules[provider_key] do
      nil ->
        raise ArgumentError,
              "Unknown provider: #{provider_key}. Available providers: #{inspect(Map.keys(@provider_modules))}"

      module ->
        module
    end
  end
end

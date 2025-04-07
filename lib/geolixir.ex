defmodule Geolixir do
  @moduledoc """
  Main geocoding module with unified interface.
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
  Geocode an address.
  """
  @spec geocode(String.t(), keyword()) :: {:ok, Result.t()} | {:error, any()}
  def geocode(address, opts \\ []) do
    provider = resolve_provider(opts[:provider] || @default_provider)
    provider.geocode(%{address: address}, opts)
  end

  @doc """
  Reverse geocode coordinates.
  """
  @spec reverse_geocode(float(), float(), keyword()) ::
          {:ok, Result.t()} | {:error, any()}
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

defmodule GeolixirTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.Providers.{Geoapify, OpenStreetMaps}
  alias Geolixir.Result

  @address "London"
  @lat 51.50
  @lon -0.127

  setup do
    Mimic.copy(OpenStreetMaps)
    Mimic.copy(Geoapify)
  end

  describe "geocode/2" do
    test "uses the default provider (OpenStreetMaps) when none is specified" do
      expect(OpenStreetMaps, :geocode, fn %{address: @address}, [] ->
        {:ok, %Result{metadata: %{"provider" => "osm"}}}
      end)

      assert {:ok, %Result{metadata: %{"provider" => "osm"}}} = Geolixir.geocode(@address)
    end

    test "uses the specified provider" do
      expect(Geoapify, :geocode, fn %{address: @address},
                                    provider: :geoapify,
                                    api_key: "test_key" ->
        {:ok, %Result{metadata: %{"provider" => "geoapify"}}}
      end)

      assert {:ok, %Result{metadata: %{"provider" => "geoapify"}}} =
               Geolixir.geocode(@address, provider: :geoapify, api_key: "test_key")
    end

    test "returns an error tuple when the provider returns an error" do
      expect(Geoapify, :geocode, fn %{address: @address},
                                    provider: :geoapify,
                                    api_key: "test_key" ->
        {:error, :provider_error}
      end)

      assert {:error, :provider_error} =
               Geolixir.geocode(@address, provider: :geoapify, api_key: "test_key")
    end

    test "raises an error when key is missing for a provider that requires it" do
      assert_raise ArgumentError,
                   ~r/API requires an API key. Please provide :api_key in options./,
                   fn -> Geolixir.geocode(@address, provider: :geoapify) end
    end

    test "raises an error for an unknown provider" do
      assert_raise ArgumentError,
                   ~r/Unknown provider: unknown_provider/,
                   fn -> Geolixir.geocode(@address, provider: :unknown_provider) end
    end
  end

  describe "reverse_geocode/3" do
    test "uses the default provider (OpenStreetMaps) when none is specified" do
      expect(OpenStreetMaps, :reverse_geocode, fn %{lat: @lat, lon: @lon}, [] ->
        {:ok, %Result{metadata: %{"provider" => "osm"}}}
      end)

      assert {:ok, %Result{metadata: %{"provider" => "osm"}}} =
               Geolixir.reverse_geocode(@lat, @lon)
    end

    test "uses the specified provider" do
      expect(Geoapify, :reverse_geocode, fn %{lat: @lat, lon: @lon},
                                            provider: :geoapify,
                                            api_key: "test_key" ->
        {:ok, %Result{metadata: %{"provider" => "geoapify"}}}
      end)

      assert {:ok, %Result{metadata: %{"provider" => "geoapify"}}} =
               Geolixir.reverse_geocode(@lat, @lon, provider: :geoapify, api_key: "test_key")
    end

    test "returns an error tuple when the provider returns an error" do
      expect(OpenStreetMaps, :reverse_geocode, fn %{lat: @lat, lon: @lon}, [] ->
        {:error, :provider_error}
      end)

      assert {:error, :provider_error} = Geolixir.reverse_geocode(@lat, @lon)
    end

    test "raises an error for an unknown provider" do
      assert_raise ArgumentError,
                   ~r/Unknown provider: unknown_provider/,
                   fn -> Geolixir.reverse_geocode(@lat, @lon, provider: :unknown_provider) end
    end
  end
end

defmodule Geolixir.Providers.GoogleMapsTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.HttpClient
  alias Geolixir.Providers.GoogleMaps
  alias Geolixir.Result
  alias Geolixir.Test.ProviderFixtures

  @address "London"
  @lat 51.5074
  @lon -0.1278
  @api_key "test_api_key"

  describe "geocode/2" do
    test "returns {:ok, Result.t()} on successful geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.googlemaps_success_response()
      end)

      assert {:ok, %Result{}} =
               result = GoogleMaps.geocode(%{address: @address}, api_key: @api_key)

      assert result == ProviderFixtures.googlemaps_expected_result()
    end

    test "raises ArgumentError if api_key is missing" do
      assert_raise ArgumentError,
                   ~r/Google Maps API requires an API key/,
                   fn -> GoogleMaps.geocode(%{address: @address}, []) end
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, %{status_code: 500}} =
               GoogleMaps.geocode(%{address: @address}, api_key: @api_key)
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, %HTTPoison.Error{}} =
               GoogleMaps.geocode(%{address: @address}, api_key: @api_key)
    end
  end

  describe "reverse_geocode/2" do
    test "returns {:ok, Result.t()} on successful reverse geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.googlemaps_success_response()
      end)

      assert {:ok, %Result{}} =
               result = GoogleMaps.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)

      assert result == ProviderFixtures.googlemaps_expected_result()
    end

    test "raises ArgumentError if api_key is missing" do
      assert_raise ArgumentError,
                   ~r/Google Maps API requires an API key/,
                   fn -> GoogleMaps.reverse_geocode(%{lat: @lat, lon: @lon}) end
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, %{status_code: 500}} =
               GoogleMaps.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, %HTTPoison.Error{}} =
               GoogleMaps.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)
    end
  end
end

defmodule Geolixir.Providers.GeocodingTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.HttpClient
  alias Geolixir.Providers.Geocoding
  alias Geolixir.Result
  alias Geolixir.Test.ProviderFixtures

  @address "London"
  @lat 51.5074
  @lon -0.1278
  @api_key "test_api_key"

  describe "geocode/2" do
    test "returns {:ok, Result.t()} on successful geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.osm_geocode_success_response()
      end)

      assert {:ok, %Result{}} =
               result = Geocoding.geocode(%{address: @address}, api_key: @api_key)

      assert result == ProviderFixtures.osm_expected_result()
    end

    test "returns {:error, reason} on empty geocoding response" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_empty_response() end)

      assert {:error, "No results found for the given address"} =
               Geocoding.geocode(%{address: @address}, api_key: @api_key)
    end

    test "raises ArgumentError if api_key is missing" do
      assert_raise ArgumentError,
                   ~r/Geocoding API requires an API key/,
                   fn -> Geocoding.geocode(%{address: @address}) end
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, %{status_code: 500}} =
               Geocoding.geocode(%{address: @address}, api_key: @api_key)
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, %HTTPoison.Error{}} =
               Geocoding.geocode(%{address: @address}, api_key: @api_key)
    end
  end

  describe "reverse_geocode/2" do
    test "returns {:ok, Result.t()} on successful reverse geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.osm_geocode_success_response()
      end)

      assert {:ok, %Result{}} =
               result = Geocoding.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)

      assert result == ProviderFixtures.osm_expected_result()
    end

    test "returns {:error, reason} on failure reverse geocoding" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.unable_to_reverse_geocoding() end)

      assert {:error, "Unable to geocode"} =
               Geocoding.reverse_geocode(%{address: @address}, api_key: @api_key)
    end

    test "raises ArgumentError if api_key is missing" do
      assert_raise ArgumentError,
                   ~r/Geocoding API requires an API key/,
                   fn -> Geocoding.reverse_geocode(%{lat: @lat, lon: @lon}) end
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, %{status_code: 500}} =
               Geocoding.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, %HTTPoison.Error{}} =
               Geocoding.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)
    end
  end
end

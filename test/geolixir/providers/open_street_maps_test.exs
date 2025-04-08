defmodule Geolixir.Providers.OpenStreetMapsTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.HttpClient
  alias Geolixir.Providers.OpenStreetMaps
  alias Geolixir.Result
  alias Geolixir.Test.ProviderFixtures

  @address "London"
  @lat 51.5074
  @lon -0.1278

  describe "geocode/2" do
    test "returns {:ok, Result.t()} on successful geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.osm_geocode_success_response()
      end)

      assert {:ok, %Result{}} = result = OpenStreetMaps.geocode(%{address: @address})
      assert result == ProviderFixtures.osm_expected_result()
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)
      assert {:error, %{status_code: 500}} = OpenStreetMaps.geocode(%{address: @address})
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)
      assert {:error, %HTTPoison.Error{}} = OpenStreetMaps.geocode(%{address: @address})
    end
  end

  describe "reverse_geocode/2" do
    test "returns {:ok, Result.t()} on successful reverse geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.osm_reverse_geocode_success_response()
      end)

      assert {:ok, %Result{}} =
               result = OpenStreetMaps.reverse_geocode(%{lat: @lat, lon: @lon})

      assert result == ProviderFixtures.osm_expected_result()
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, %{status_code: 500}} =
               OpenStreetMaps.reverse_geocode(%{lat: @lat, lon: @lon})
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, %HTTPoison.Error{}} =
               OpenStreetMaps.reverse_geocode(%{lat: @lat, lon: @lon})
    end
  end
end

defmodule Geolixir.Providers.OpenStreetMapTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.HttpClient
  alias Geolixir.Providers.OpenStreetMap
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

      assert {:ok, %Result{}} = result = OpenStreetMap.geocode(%{address: @address})
      assert result == ProviderFixtures.osm_expected_result()
    end

    test "returns {:error, reason} on empty geocoding response" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_empty_response() end)

      assert {:error, "No results found for the given address"} =
               OpenStreetMap.geocode(%{address: @address})
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)
      assert {:error, %{status_code: 500}} = OpenStreetMap.geocode(%{address: @address})
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)
      assert {:error, %HTTPoison.Error{}} = OpenStreetMap.geocode(%{address: @address})
    end
  end

  describe "reverse_geocode/2" do
    test "returns {:ok, Result.t()} on successful reverse geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.osm_reverse_geocode_success_response()
      end)

      assert {:ok, %Result{}} =
               result = OpenStreetMap.reverse_geocode(%{lat: @lat, lon: @lon})

      assert result == ProviderFixtures.osm_expected_result()
    end

    test "returns {:error, reason} on failure reverse geocoding" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.unable_to_reverse_geocoding() end)
      assert {:error, "Unable to geocode"} = OpenStreetMap.reverse_geocode(%{address: @address})
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, %{status_code: 500}} =
               OpenStreetMap.reverse_geocode(%{lat: @lat, lon: @lon})
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, %HTTPoison.Error{}} =
               OpenStreetMap.reverse_geocode(%{lat: @lat, lon: @lon})
    end
  end
end

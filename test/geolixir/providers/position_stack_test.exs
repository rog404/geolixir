defmodule Geolixir.Providers.PositionStackTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.HttpClient
  alias Geolixir.Providers.PositionStack
  alias Geolixir.Result
  alias Geolixir.Test.ProviderFixtures

  @address "London"
  @lat 51.5074
  @lon -0.1278
  @api_key "test_api_key"

  describe "geocode/2" do
    test "returns {:ok, Result.t()} on successful geocoding" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.position_stack_success_response()
      end)

      assert {:ok, %Result{}} =
               result = PositionStack.geocode(%{address: @address}, api_key: @api_key)

      assert result == ProviderFixtures.position_stack_expected_result()
    end

    test "raises ArgumentError if api_key is missing" do
      assert_raise ArgumentError,
                   ~r/PositionStack API requires an API key/,
                   fn -> PositionStack.geocode(%{address: @address}) end
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)
      assert {:error, {:error, %{status_code: 500}}} =
               PositionStack.geocode(%{address: @address}, api_key: @api_key)
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)
      assert {:error, {:error, %HTTPoison.Error{}}} =
               PositionStack.geocode(%{address: @address}, api_key: @api_key)
    end
  end

  describe "reverse_geocode/2" do
    test "returns {:ok, Result.t()} on successful reverse geocoding (assuming prepare_payload fix)" do
      expect(HttpClient, :request, fn %{method: :get} ->
        ProviderFixtures.position_stack_success_response()
      end)

      assert {:ok, %Result{}} =
               result =
               PositionStack.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)

      assert result == ProviderFixtures.position_stack_expected_result()
    end

    test "raises ArgumentError if api_key is missing" do
      assert_raise ArgumentError,
                   ~r/PositionStack API requires an API key/,
                   fn -> PositionStack.reverse_geocode(%{lat: @lat, lon: @lon}) end
    end

    test "returns {:error, reason} on HTTP client error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_error_response() end)

      assert {:error, {:error, %{status_code: 500}}} =
               PositionStack.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)
    end

    test "returns {:error, reason} on HTTPoison error" do
      expect(HttpClient, :request, fn _ -> ProviderFixtures.http_poison_error() end)

      assert {:error, {:error, %HTTPoison.Error{}}} =
               PositionStack.reverse_geocode(%{lat: @lat, lon: @lon}, api_key: @api_key)
    end
  end
end

defmodule Geolixir.HttpClientTest do
  use ExUnit.Case, async: true
  use Mimic

  alias Geolixir.HttpClient

  @base_url "http://example.com/api"
  @success_json_body ~s({"status": "ok", "data": {"key": "value"}})
  @success_text_body "Success"
  @error_json_body ~s({"error": "Not Found"})
  @error_text_body "Server Error"

  describe "request/2" do
    test "handles successful GET request with JSON response" do
      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: %{}] ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: @success_json_body,
           headers: [{"Content-Type", "application/json"}]
         }}
      end)

      request_map = %{method: :get, url: @base_url}

      assert {:ok,
              %{
                status_code: 200,
                body: %{"status" => "ok", "data" => %{"key" => "value"}},
                headers: [{"Content-Type", "application/json"}]
              }} = HttpClient.request(request_map)
    end

    test "handles successful GET request with non-JSON response" do
      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: %{}] ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: @success_text_body,
           headers: [{"Content-Type", "text/plain"}]
         }}
      end)

      request_map = %{method: :get, url: @base_url}

      assert {:ok,
              %{
                status_code: 200,
                body: @success_text_body,
                headers: [{"Content-Type", "text/plain"}]
              }} = HttpClient.request(request_map)
    end

    test "handles error response from server with JSON body" do
      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: %{}] ->
        {:ok,
         %HTTPoison.Response{
           status_code: 404,
           body: @error_json_body,
           headers: [{"Content-Type", "application/json"}]
         }}
      end)

      request_map = %{method: :get, url: @base_url}

      assert {:error,
              %{
                status_code: 404,
                body: %{"error" => "Not Found"},
                headers: [{"Content-Type", "application/json"}]
              }} = HttpClient.request(request_map)
    end

    test "handles error response from server with non-JSON body" do
      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: %{}] ->
        {:ok,
         %HTTPoison.Response{
           status_code: 500,
           body: @error_text_body,
           headers: [{"Content-Type", "text/plain"}]
         }}
      end)

      request_map = %{method: :get, url: @base_url}

      assert {:error,
              %{
                status_code: 500,
                body: @error_text_body,
                headers: [{"Content-Type", "text/plain"}]
              }} = HttpClient.request(request_map)
    end

    test "handles HTTPoison connection error" do
      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: %{}] ->
        {:error, %HTTPoison.Error{reason: :econnrefused, id: nil}}
      end)

      request_map = %{method: :get, url: @base_url}

      assert {:error, %HTTPoison.Error{reason: :econnrefused}} = HttpClient.request(request_map)
    end

    test "sends query parameters correctly" do
      query = %{key1: "value1", key2: "value2"}

      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: ^query] ->
        {:ok, %HTTPoison.Response{status_code: 200, body: @success_json_body, headers: []}}
      end)

      request_map = %{method: :get, url: @base_url, query_params: query}
      assert {:ok, %{status_code: 200}} = HttpClient.request(request_map)
    end

    test "sends headers correctly" do
      headers = [{"Accept", "application/json"}, {"X-Custom", "value"}]

      expect(HTTPoison, :request, fn :get, @base_url, "", ^headers, [params: %{}] ->
        {:ok, %HTTPoison.Response{status_code: 200, body: @success_json_body, headers: []}}
      end)

      request_map = %{method: :get, url: @base_url, headers: headers}
      assert {:ok, %{status_code: 200}} = HttpClient.request(request_map)
    end

    test "passes http_options correctly" do
      http_options = [recv_timeout: 10_000, ssl: [verify: :verify_peer]]

      expect(HTTPoison, :request, fn :get, @base_url, "", [], [params: %{}] ++ ^http_options ->
        {:ok, %HTTPoison.Response{status_code: 200, body: @success_json_body, headers: []}}
      end)

      request_map = %{method: :get, url: @base_url}

      assert {:ok, %{status_code: 200}} =
               HttpClient.request(request_map, http_options: http_options)
    end
  end
end

defmodule Geolixir.HttpClient do
  @moduledoc """
  A simple HTTP client wrapper around HTTPoison, tailored for Geolixir providers.

  This module handles making HTTP requests, processing responses (including basic
  JSON decoding), and normalizing success/error tuples. It is used internally
  by the various geocoding providers.
  """

  @typedoc """
  Represents the configuration for an HTTP request.
  - `:method`: The HTTP method (e.g., `:get`, `:post`).
  - `:url`: The target URL string.
  - `:query_params`: (Optional) A map of query parameters. Defaults to `%{}%`.
  - `:headers`: (Optional) A list of HTTP header tuples. Defaults to `[]`.
  """
  @type request_config :: %{
          required(:method) => :get | :post | :put | :delete | :patch,
          required(:url) => String.t(),
          optional(:query_params) => map(),
          optional(:headers) => [{String.t(), String.t()}]
        }

  @typedoc """
  Represents options passed to the underlying HTTP client (HTTPoison).
  See `HTTPoison.request/5` options for details.
  """
  @type http_options :: keyword()

  @typedoc """
  Represents a successful response map after processing.
  - `:status_code`: The HTTP status code (integer).
  - `:body`: The response body, decoded as JSON if possible, otherwise the raw string.
  - `:headers`: A list of response header tuples.
  """
  @type success_response :: %{
          status_code: non_neg_integer(),
          body: any(),
          headers: [{String.t(), String.t()}]
        }

  @typedoc """
  Represents an error response map after processing.
  - `:status_code`: The HTTP status code (integer).
  - `:body`: The response body, decoded as JSON if possible, otherwise the raw string.
  - `:headers`: A list of response header tuples.
  """
  @type error_response :: %{
          status_code: non_neg_integer(),
          body: any(),
          headers: [{String.t(), String.t()}]
        }

  @doc """
  Makes an HTTP request using HTTPoison.

  It automatically decodes JSON responses and wraps the result in standardized
  `{:ok, response_map}` or `{:error, error_map | HTTPoison.Error.t()}` tuples.

  ## Parameters
    - `request_config`: A `t:request_config/0` map containing `:method`, `:url`,
      and optional `:query_params` and `:headers`.
    - `config`: (Optional) A keyword list for additional configuration.
      - `:http_options`: A `t:http_options/0` keyword list passed directly to `HTTPoison.request/5`.

  ## Returns
    - `{:ok, success_response()}`: For successful HTTP requests (status 2xx).
    - `{:error, error_response()}`: For HTTP requests with error status codes (non-2xx).
    - `{:error, %HTTPoison.Error{}}`: If the HTTP request itself fails (e.g., connection error).
  """
  @spec request(request_config(), config :: keyword()) ::
          {:ok, success_response()} | {:error, error_response() | HTTPoison.Error.t()}
  def request(%{method: method, url: url} = request_config, config \\ []) do
    # Extract parameters from request_config
    params = Map.get(request_config, :query_params, %{})
    headers = Map.get(request_config, :headers, [])
    http_options = Keyword.get(config, :http_options, [])

    # Prepare options for HTTPoison
    opts = [params: params] |> Keyword.merge(http_options)

    case HTTPoison.request(method, url, "", headers, opts) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        process_response(response, :ok)

      {:ok, %HTTPoison.Response{} = response} ->
        process_response(response, :error)

      {:error, %HTTPoison.Error{} = error} ->
        {:error, error}
    end
  end

  # Process HTTP responses and handle JSON decoding
  defp process_response(
         %HTTPoison.Response{status_code: status, body: body, headers: headers},
         result_type
       ) do
    case JSON.decode(body) do
      {:ok, decoded} ->
        {result_type, %{status_code: status, body: decoded, headers: headers}}

      {:error, _reason} ->
        {result_type, %{status_code: status, body: body, headers: headers}}
    end
  end
end

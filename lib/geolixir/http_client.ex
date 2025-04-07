defmodule Geolixir.HttpClient do
  @moduledoc """
  Handles HTTP requests for geolocation services
  """

  @doc """
  Makes an HTTP request to a geolocation service.

  ## Parameters
    - request: A map containing :method, :url, and optional :query_params and :headers
  """
  def request(%{method: method, url: url} = request, config \\ []) do
    # Extract optional parameters with defaults
    params = Map.get(request, :query_params, %{})
    headers = Map.get(request, :headers, [])
    http_options = Keyword.get(config, :http_options, [])

    # Basic options setup
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

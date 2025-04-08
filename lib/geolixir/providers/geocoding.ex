defmodule Geolixir.Providers.Geocoding do
  @moduledoc """
  GeoCoding geocoding provider.
  Does REQUIRES a key.
  """

  alias Geolixir.{Bounds, Coords, Location, Result}

  use Geolixir.Providers.Base,
    endpoint: "https://geocode.maps.co/",
    search_path: "/search",
    reverse_path: "/reverse",
    query_word: "q"

  @key_params_name "api_key"

  @address_component_mapping %{
    "display_name" => :formatted_address
  }

  @impl true
  def geocode(payload, opts) do
    payload
    |> prepare_payload(:geocode)
    |> request(:search, opts)
    |> process_response()
  end

  @impl true
  def reverse_geocode(payload, opts) do
    payload
    |> prepare_payload(:reverse_geocode)
    |> request(:reverse, opts)
    |> process_response()
  end

  defp request(payload, action, opts) do
    path = if action == :search, do: @search_path, else: @reverse_path
    url = @endpoint <> path

    api_key =
      opts[:api_key] ||
        raise ArgumentError,
              "Geocoding API requires an API key. Please provide :api_key in options."

    Geolixir.HttpClient.request(%{
      method: :get,
      url: url,
      query_params: Map.merge(payload, %{@key_params_name => api_key})
    })
  end

  defp prepare_payload(payload, :geocode) do
    %{@query_word => payload[:address]}
  end

  defp prepare_payload(payload, :reverse_geocode) do
    %{lat: payload[:lat], lon: payload[:lon]}
  end

  defp process_response({:ok, %{body: body}}) do
    body
    |> List.first()
    |> build_result()
  end

  defp process_response(response), do: response

  defp build_result(response) do
    {:ok,
     %Result{
       coordinates: parse_coords(response),
       bounds: parse_bounds(response),
       location: parse_location(response),
       metadata: response
     }}
  end

  defp parse_coords(%{"lat" => lat, "lon" => lon}) do
    %Coords{lat: lat, lon: lon}
  end

  defp parse_bounds(%{"boundingbox" => bbox}) do
    [north, south, west, east] = bbox |> Enum.map(&elem(Float.parse(&1), 0))
    %Bounds{top: north, right: east, bottom: south, left: west}
  end

  defp parse_bounds(_), do: %Bounds{}

  defp parse_location(response) do
    reduce = fn {type, name}, location ->
      struct(location, [{@address_component_mapping[type], name}])
    end

    response
    |> Enum.reduce(%Location{}, reduce)
  end
end

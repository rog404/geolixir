defmodule Geolixir.Providers.Geoapify do
  @moduledoc """
  Geoapify geocoding provider.
  Does REQUIRES a key.
  """

  alias Geolixir.{Bounds, Coords, Location, Result}

  use Geolixir.Providers.Base,
    endpoint: "https://api.geoapify.com/v1/geocode",
    search_path: "/search",
    reverse_path: "/reverse",
    query_word: "text"

  @key_params_name "apiKey"

  @address_component_mapping %{
    "country" => :country,
    "country_code" => :country_code,
    "state" => :state,
    "suburb" => :county,
    "county" => :county,
    "city" => :city,
    "postcode" => :postal_code,
    "address_line1" => :street,
    "housenumber" => :street_number,
    "formatted" => :formatted_address
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
              "Geoapify API requires an API key. Please provide :api_key in options."

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
    |> Map.get("features", [])
    |> List.first()
    |> build_result()
  end

  defp process_response(response), do: response

  defp build_result(nil), do: {:error, :address_not_found}

  defp build_result(response) do
    {:ok,
     %Result{
       coordinates: parse_coords(response["geometry"]),
       bounds: parse_bounds(response),
       location: parse_location(response["properties"]),
       metadata: response
     }}
  end

  defp parse_coords(%{"coordinates" => [lon, lat]}) do
    %Coords{lat: lat, lon: lon}
  end

  defp parse_bounds(%{"boundingbox" => [north, south, west, east]}) do
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

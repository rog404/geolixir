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

  @defaults %{format: "jsonv2", "accept-language": "en", addressdetails: 1}

  @address_component_mapping %{
    "country" => :country,
    "country_code" => :country_code,
    "state" => :state,
    "suburb" => :county,
    "county" => :county,
    "city" => :city,
    "postcode" => :postal_code,
    "road" => :street,
    "house_number" => :street_number
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
      query_params: Map.merge(payload, %{@key_params_name => api_key}) |> Map.merge(@defaults)
    })
  end

  defp prepare_payload(payload, :geocode) do
    %{@query_word => payload[:address]}
  end

  defp prepare_payload(payload, :reverse_geocode) do
    %{lat: payload[:lat], lon: payload[:lon]}
  end

  defp process_response({:ok, %{body: body}}) when is_list(body) do
    body
    |> List.first()
    |> build_result()
  end

  defp process_response({:ok, %{body: body}}) do
    build_result(body)
  end

  defp process_response(response), do: response

  defp build_result(nil) do
    {:error, "No results found for the given address"}
  end

  defp build_result([]) do
    {:error, "No results found for the given address"}
  end

  defp build_result(%{"error" => error}) do
    {:error, error}
  end

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
    [lat, lon] = [lat, lon] |> Enum.map(&elem(Float.parse(&1), 0))
    %Coords{lat: lat, lon: lon}
  end

  defp parse_bounds(%{"boundingbox" => bbox}) do
    [north, south, west, east] = bbox |> Enum.map(&elem(Float.parse(&1), 0))
    %Bounds{top: north, right: east, bottom: south, left: west}
  end

  defp parse_bounds(_), do: %Bounds{}

  defp parse_location(
         %{
           "address" => address
         } = response
       ) do
    reduce = fn {type, name}, location ->
      struct(location, [{@address_component_mapping[type], name}])
    end

    location = %Location{
      formatted_address: response["display_name"]
    }

    address
    |> Enum.reduce(location, reduce)
  end

  defp parse_location(_), do: %Location{}
end

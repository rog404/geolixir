defmodule Geolixir.Providers.GoogleMaps do
  @moduledoc """
  Google Maps geocoding provider.
  Requires an API key.
  """

  alias Geolixir.{Bounds, Coords, Location, Result}

  use Geolixir.Providers.Base,
    endpoint: "https://maps.googleapis.com/maps/api/geocode/json?",
    search_path: "",
    reverse_path: "",
    query_word: "address"

  @key_params_name "key"

  @address_component_mapping %{
    "country" => :country,
    "country_code" => :country_code,
    "administrative_area_level_1" => :state,
    "administrative_area_level_2" => :county,
    "locality" => :city,
    "postal_code" => :postal_code,
    "route" => :street,
    "street_number" => :street_number
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
              "Google Maps API requires an API key. Please provide :api_key in options."

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
    %{latlng: "#{payload[:lat]},#{payload[:lon]}"}
  end

  defp process_response({:ok, %{body: %{"status" => "ZERO_RESULTS"}}}) do
    {:error, "No results found for the given address"}
  end

  defp process_response({:ok, %{body: %{"status" => status, "error_message" => msg}}})
       when status != "OK" do
    {:error, "Google Maps API error: #{msg}"}
  end

  defp process_response({:ok, %{body: %{"status" => status}}}) when status != "OK" do
    {:error, "Google Maps API returned status: #{status}"}
  end

  defp process_response({:ok, %{body: body}}) do
    body
    |> Map.get("results", [])
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
       location: parse_location(response),
       metadata: response
     }}
  end

  defp parse_coords(%{"location" => %{"lat" => lat, "lng" => lon}}) do
    %Coords{lat: lat, lon: lon}
  end

  defp parse_bounds(%{"geometry" => %{"bounds" => %{"northeast" => ne, "southwest" => sw}}}) do
    %Bounds{
      top: ne["lat"],
      right: ne["lng"],
      bottom: sw["lat"],
      left: sw["lng"]
    }
  end

  defp parse_bounds(_), do: %Bounds{}

  defp parse_location(
         %{
           "address_components" => address
         } = response
       ) do
    reduce = fn %{"long_name" => name, "types" => [type | _rest]}, location ->
      case @address_component_mapping[type] do
        nil -> location
        field -> struct(location, [{field, name}])
      end
    end

    location = %Location{
      formatted_address: response["formatted_address"],
      country_code:
        address
        |> Enum.find(fn %{"types" => [type | _rest]} -> type == "country" end)
        |> then(fn
          nil -> nil
          component -> Map.get(component, "short_name")
        end)
    }

    address
    |> Enum.reduce(location, reduce)
  end
end

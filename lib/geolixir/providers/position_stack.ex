defmodule Geolixir.Providers.PositionStack do
  @moduledoc """
  PositionStack geocoding provider.
  Does REQUIRES a key.
  """

  alias Geolixir.{Coords, Location, Result}

  use Geolixir.Providers.Base,
    endpoint: "https://api.positionstack.com/v1",
    search_path: "/forward",
    reverse_path: "/reverse",
    query_word: "query"

  @key_params_name "access_key"

  @address_component_mapping %{
    "country" => :country,
    "country_code" => :country_code,
    "region" => :state,
    "suburb" => :county,
    "county" => :county,
    "locality" => :city,
    "postal_code" => :postal_code,
    "street" => :street,
    "number" => :street_number,
    "label" => :formatted_address
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
              "PositionStack API requires an API key. Please provide :api_key in options."

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
    %{@query_word => "#{payload[:lat]}, #{payload[:lon]}"}
  end

  defp process_response({:ok, %{body: body}}) do
    body
    |> Map.get("data", [])
    |> List.first()
    |> build_result()
  end

  defp process_response(response) do
    {:error, response}
  end

  defp build_result(response) do
    {:ok,
     %Result{
       coordinates: parse_coords(response),
       location: parse_location(response),
       metadata: response
     }}
  end

  defp parse_coords(%{"latitude" => lat, "longitude" => lon}) do
    %Coords{lat: lat, lon: lon}
  end

  defp parse_location(response) do
    reduce = fn {type, name}, location ->
      struct(location, [{@address_component_mapping[type], name}])
    end

    response
    |> Enum.reduce(%Location{}, reduce)
  end
end

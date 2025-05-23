# credo:disable-for-this-file
defmodule Geolixir.Test.ProviderFixtures do
  @moduledoc """
  Provides mock response fixtures for different geocoding providers.
  """

  alias Geolixir.{Bounds, Coords, Location, Result}

  # --- OpenStreetMap & Geocoding Fixtures ---

  @osm_response_map %{
    "address" => %{
      "ISO3166-2-lvl4" => "GB-ENG",
      "ISO3166-2-lvl8" => "GB-WSM",
      "city" => "City of Westminster",
      "country" => "United Kingdom",
      "country_code" => "gb",
      "historic" => "Mileage Central Point of London Plaque",
      "neighbourhood" => "Seven Dials",
      "postcode" => "SW1A 2DR",
      "road" => "Charing Cross",
      "state" => "England",
      "state_district" => "Greater London",
      "suburb" => "Waterloo",
      "town" => "Southwark"
    },
    "addresstype" => "historic",
    "boundingbox" => ["51.5073633", "51.5074633", "-0.1277365", "-0.1276365"],
    "category" => "historic",
    "display_name" =>
      "Mileage Central Point of London Plaque, Charing Cross, Seven Dials, Waterloo, Southwark, City of Westminster, Greater London, England, SW1A 2DR, United Kingdom",
    "importance" => 9.307927061870783e-5,
    "lat" => "51.5074133",
    "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
    "lon" => "-0.1276865",
    "name" => "Mileage Central Point of London Plaque",
    "osm_id" => 7_817_017_136,
    "osm_type" => "node",
    "place_id" => 259_332_887,
    "place_rank" => 30,
    "type" => "memorial"
  }

  @osm_expected_result {:ok,
                        %Result{
                          coordinates: %Coords{lat: 51.5074133, lon: -0.1276865},
                          bounds: %Bounds{
                            top: 51.5073633,
                            right: -0.1276365,
                            bottom: 51.5074633,
                            left: -0.1277365
                          },
                          location: %Location{
                            country: "United Kingdom",
                            country_code: "gb",
                            state: "England",
                            county: "Waterloo",
                            city: "City of Westminster",
                            postal_code: "SW1A 2DR",
                            street: "Charing Cross",
                            street_number: nil,
                            formatted_address:
                              "Mileage Central Point of London Plaque, Charing Cross, Seven Dials, Waterloo, Southwark, City of Westminster, Greater London, England, SW1A 2DR, United Kingdom"
                          },
                          metadata: %{
                            "address" => %{
                              "ISO3166-2-lvl4" => "GB-ENG",
                              "ISO3166-2-lvl8" => "GB-WSM",
                              "city" => "City of Westminster",
                              "country" => "United Kingdom",
                              "country_code" => "gb",
                              "historic" => "Mileage Central Point of London Plaque",
                              "neighbourhood" => "Seven Dials",
                              "postcode" => "SW1A 2DR",
                              "road" => "Charing Cross",
                              "state" => "England",
                              "state_district" => "Greater London",
                              "suburb" => "Waterloo",
                              "town" => "Southwark"
                            },
                            "addresstype" => "historic",
                            "boundingbox" => [
                              "51.5073633",
                              "51.5074633",
                              "-0.1277365",
                              "-0.1276365"
                            ],
                            "category" => "historic",
                            "display_name" =>
                              "Mileage Central Point of London Plaque, Charing Cross, Seven Dials, Waterloo, Southwark, City of Westminster, Greater London, England, SW1A 2DR, United Kingdom",
                            "importance" => 9.307927061870783e-5,
                            "lat" => "51.5074133",
                            "licence" =>
                              "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
                            "lon" => "-0.1276865",
                            "name" => "Mileage Central Point of London Plaque",
                            "osm_id" => 7_817_017_136,
                            "osm_type" => "node",
                            "place_id" => 259_332_887,
                            "place_rank" => 30,
                            "type" => "memorial"
                          }
                        }}

  def osm_geocode_success_response do
    {
      :ok,
      %{
        status_code: 200,
        headers: [],
        body: [@osm_response_map]
      }
    }
  end

  def osm_reverse_geocode_success_response do
    {
      :ok,
      %{status_code: 200, headers: [], body: @osm_response_map}
    }
  end

  def osm_expected_result, do: @osm_expected_result

  # --- Geoapify Fixtures ---

  @geoapify_response_map %{
    "features" => [
      %{
        "bbox" => [-0.1277365, 51.5073633, -0.1276365, 51.5074633],
        "geometry" => %{
          "coordinates" => [-0.1276865, 51.5074133],
          "type" => "Point"
        },
        "properties" => %{
          "address_line1" => "Mileage Central Point of London Plaque",
          "address_line2" => "Charing Cross, London, SW1A 2DR, United Kingdom",
          "category" => "tourism.sights.memorial",
          "city" => "City of Westminster",
          "country" => "United Kingdom",
          "country_code" => "gb",
          "county" => "Greater London",
          "datasource" => %{
            "attribution" => "© OpenStreetMap contributors",
            "license" => "Open Database License",
            "sourcename" => "openstreetmap",
            "url" => "https://www.openstreetmap.org/copyright"
          },
          "district" => "Seven Dials",
          "formatted" =>
            "Mileage Central Point of London Plaque, Charing Cross, London, SW1A 2DR, United Kingdom",
          "iso3166_2" => "GB-ENG",
          "iso3166_2_sublevel" => "GB-WSM",
          "lat" => 51.5074133,
          "lon" => -0.1276865,
          "name" => "Mileage Central Point of London Plaque",
          "place_id" =>
            "519702d2fe0758c0bf59198744ebf2c04940f00103f9013037eed101000000c002019203264d696c656167652043656e7472616c20506f696e74206f66204c6f6e646f6e20506c61717565",
          "plus_code" => "9C3XGV4C+XW",
          "plus_code_short" => "4C+XW City of Westminster, Greater London, United Kingdom",
          "postcode" => "SW1A 2DR",
          "rank" => %{
            "confidence" => 1,
            "importance" => 0.60001,
            "match_type" => "full_match",
            "popularity" => 9.988490181891963
          },
          "result_type" => "amenity",
          "state" => "England",
          "state_code" => "ENG",
          "street" => "Charing Cross",
          "suburb" => "Waterloo",
          "timezone" => %{
            "abbreviation_DST" => "BST",
            "abbreviation_STD" => "GMT",
            "name" => "Europe/London",
            "offset_DST" => "+01:00",
            "offset_DST_seconds" => 3600,
            "offset_STD" => "+00:00",
            "offset_STD_seconds" => 0
          }
        },
        "type" => "Feature"
      }
    ],
    "query" => %{"text" => "Mileage Central Point of London Plaque"},
    "type" => "FeatureCollection"
  }

  @geoapify_expected_result {:ok,
                             %Result{
                               coordinates: %Coords{lon: -0.1276865, lat: 51.5074133},
                               bounds: %Bounds{top: nil, right: nil, bottom: nil, left: nil},
                               location: %Location{
                                 country: "United Kingdom",
                                 country_code: "gb",
                                 state: "England",
                                 county: "Waterloo",
                                 city: "City of Westminster",
                                 postal_code: "SW1A 2DR",
                                 street: "Mileage Central Point of London Plaque",
                                 street_number: nil,
                                 formatted_address:
                                   "Mileage Central Point of London Plaque, Charing Cross, London, SW1A 2DR, United Kingdom"
                               },
                               metadata: %{
                                 "bbox" => [-0.1277365, 51.5073633, -0.1276365, 51.5074633],
                                 "geometry" => %{
                                   "coordinates" => [-0.1276865, 51.5074133],
                                   "type" => "Point"
                                 },
                                 "properties" => %{
                                   "address_line1" => "Mileage Central Point of London Plaque",
                                   "address_line2" =>
                                     "Charing Cross, London, SW1A 2DR, United Kingdom",
                                   "category" => "tourism.sights.memorial",
                                   "city" => "City of Westminster",
                                   "country" => "United Kingdom",
                                   "country_code" => "gb",
                                   "county" => "Greater London",
                                   "datasource" => %{
                                     "attribution" => "© OpenStreetMap contributors",
                                     "license" => "Open Database License",
                                     "sourcename" => "openstreetmap",
                                     "url" => "https://www.openstreetmap.org/copyright"
                                   },
                                   "district" => "Seven Dials",
                                   "formatted" =>
                                     "Mileage Central Point of London Plaque, Charing Cross, London, SW1A 2DR, United Kingdom",
                                   "iso3166_2" => "GB-ENG",
                                   "iso3166_2_sublevel" => "GB-WSM",
                                   "lat" => 51.5074133,
                                   "lon" => -0.1276865,
                                   "name" => "Mileage Central Point of London Plaque",
                                   "place_id" =>
                                     "519702d2fe0758c0bf59198744ebf2c04940f00103f9013037eed101000000c002019203264d696c656167652043656e7472616c20506f696e74206f66204c6f6e646f6e20506c61717565",
                                   "plus_code" => "9C3XGV4C+XW",
                                   "plus_code_short" =>
                                     "4C+XW City of Westminster, Greater London, United Kingdom",
                                   "postcode" => "SW1A 2DR",
                                   "rank" => %{
                                     "confidence" => 1,
                                     "importance" => 0.60001,
                                     "match_type" => "full_match",
                                     "popularity" => 9.988490181891963
                                   },
                                   "result_type" => "amenity",
                                   "state" => "England",
                                   "state_code" => "ENG",
                                   "street" => "Charing Cross",
                                   "suburb" => "Waterloo",
                                   "timezone" => %{
                                     "abbreviation_DST" => "BST",
                                     "abbreviation_STD" => "GMT",
                                     "name" => "Europe/London",
                                     "offset_DST" => "+01:00",
                                     "offset_DST_seconds" => 3600,
                                     "offset_STD" => "+00:00",
                                     "offset_STD_seconds" => 0
                                   }
                                 },
                                 "type" => "Feature"
                               }
                             }}

  def geoapify_success_response do
    {
      :ok,
      %{
        status_code: 200,
        headers: [],
        body: @geoapify_response_map
      }
    }
  end

  def geoapify_expected_result, do: @geoapify_expected_result

  # --- PositionStack Fixtures ---

  @ps_response_map %{
    "data" => [
      %{
        "administrative_area" => nil,
        "confidence" => 0.8,
        "continent" => "Europe",
        "country" => "United Kingdom",
        "country_code" => "GBR",
        "county" => "Lambeth",
        "label" => "Mileage Central Point of London Plaque, London, England, United Kingdom",
        "latitude" => 51.507413,
        "locality" => "London",
        "longitude" => -0.127687,
        "name" => "Mileage Central Point of London Plaque",
        "neighbourhood" => "Charing Cross",
        "number" => nil,
        "postal_code" => nil,
        "region" => "London",
        "region_code" => nil,
        "street" => nil,
        "type" => "venue"
      },
      %{
        "administrative_area" => "Central Township",
        "confidence" => 1,
        "continent" => "North America",
        "country" => "United States",
        "country_code" => "USA",
        "county" => "Jefferson County",
        "label" => "Central Point Road, Central, MO, USA",
        "latitude" => 38.300828,
        "locality" => "Central",
        "longitude" => -90.538656,
        "name" => "Central Point Road",
        "neighbourhood" => nil,
        "number" => nil,
        "postal_code" => nil,
        "region" => "Missouri",
        "region_code" => "MO",
        "street" => "Central Point Road",
        "type" => "street"
      }
    ]
  }

  @ps_expected_result {:ok,
                       %Result{
                         coordinates: %Coords{lat: 51.507413, lon: -0.127687},
                         bounds: nil,
                         location: %Location{
                           country: "United Kingdom",
                           country_code: "GBR",
                           state: "London",
                           county: "Lambeth",
                           city: "London",
                           postal_code: nil,
                           street: nil,
                           street_number: nil,
                           formatted_address:
                             "Mileage Central Point of London Plaque, London, England, United Kingdom"
                         },
                         metadata: %{
                           "administrative_area" => nil,
                           "confidence" => 0.8,
                           "continent" => "Europe",
                           "country" => "United Kingdom",
                           "country_code" => "GBR",
                           "county" => "Lambeth",
                           "label" =>
                             "Mileage Central Point of London Plaque, London, England, United Kingdom",
                           "latitude" => 51.507413,
                           "locality" => "London",
                           "longitude" => -0.127687,
                           "name" => "Mileage Central Point of London Plaque",
                           "neighbourhood" => "Charing Cross",
                           "number" => nil,
                           "postal_code" => nil,
                           "region" => "London",
                           "region_code" => nil,
                           "street" => nil,
                           "type" => "venue"
                         }
                       }}

  def position_stack_success_response do
    {:ok,
     %{
       status_code: 200,
       headers: [],
       body: @ps_response_map
     }}
  end

  def position_stack_expected_result, do: @ps_expected_result

  # --- Common Error Fixtures ---

  def unable_to_reverse_geocoding do
    {
      :ok,
      %{
        status_code: 200,
        headers: [],
        body: %{"error" => "Unable to geocode"}
      }
    }
  end

  def http_empty_response do
    {
      :ok,
      %{
        status_code: 200,
        headers: [],
        body: []
      }
    }
  end

  def http_error_response(status_code \\ 500, body \\ "Server Error") do
    # Simulate an error response tuple from HttpClient
    {:error, %{status_code: status_code, body: body, headers: []}}
  end

  def http_poison_error do
    # Simulate a direct error from HTTPoison via HttpClient
    {:error, %HTTPoison.Error{reason: :econnrefused, id: nil}}
  end
end

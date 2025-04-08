defmodule Geolixir.Result do
  @moduledoc """
  Represents a standardized result from a geocoding or reverse geocoding operation.

  This struct consolidates information parsed from various provider responses into
  a consistent format.
  """

  alias Geolixir.{Bounds, Coords, Location}

  @typedoc """
  The struct holding standardized geolocation results.
  - `:coordinates`: A `Geolixir.Coords` struct with latitude and longitude.
  - `:bounds`: A `Geolixir.Bounds` struct representing the bounding box, if available.
  - `:location`: A `Geolixir.Location` struct containing address components.
  - `:metadata`: The original, raw response map from the provider for debugging or accessing provider-specific fields.
  """
  @type t :: %__MODULE__{
          coordinates: Coords.t() | nil,
          bounds: Bounds.t() | nil,
          location: Location.t() | nil,
          metadata: map() | nil
        }

  defstruct coordinates: nil,
            bounds: nil,
            location: nil,
            metadata: nil
end

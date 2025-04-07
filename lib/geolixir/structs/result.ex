defmodule Geolixir.Result do
  @moduledoc """
  Represents the result of a geolocation query, including coordinates, bounds, and metadata.
  """

  alias Geolixir.{Bounds, Coords, Location}

  @typedoc "Geographic coordinates with associated metadata"
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

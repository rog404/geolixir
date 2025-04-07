defmodule Geolixir.Coords do
  @moduledoc """
  Represents geographic coordinates (latitude and longitude) with associated metadata.
  """

  @typedoc "Geographic coordinates with associated metadata"
  @type t :: %__MODULE__{
          lat: float() | nil,
          lon: float() | nil
        }

  defstruct lat: nil,
            lon: nil
end

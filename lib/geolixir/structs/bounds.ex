defmodule Geolixir.Bounds do
  @moduledoc """
  Represents geographical boundaries with northeast and southwest coordinates.
  """

  @type t :: %__MODULE__{
          top: float() | nil,
          right: float() | nil,
          bottom: float() | nil,
          left: float() | nil
        }

  defstruct top: nil,
            right: nil,
            bottom: nil,
            left: nil
end

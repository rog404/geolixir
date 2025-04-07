defmodule Geolixir.Location do
  @moduledoc """
  Represents a geographical location with address components.
  """

  @type t :: %__MODULE__{
          country: String.t() | nil,
          country_code: String.t() | nil,
          state: String.t() | nil,
          county: String.t() | nil,
          city: String.t() | nil,
          postal_code: String.t() | nil,
          street: String.t() | nil,
          street_number: String.t() | nil,
          formatted_address: String.t() | nil
        }

  defstruct country: nil,
            country_code: nil,
            state: nil,
            county: nil,
            city: nil,
            postal_code: nil,
            street: nil,
            street_number: nil,
            formatted_address: nil
end

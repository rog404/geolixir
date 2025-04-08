defmodule Geolixir.Provider do
  @moduledoc """
  Defines the behavior for all Geolixir geocoding providers.

  Each provider module must implement the required callbacks defined here.
  This ensures a consistent interface across different geocoding services.

  Providers typically handle:
  - Constructing the correct API request URL and parameters.
  - Making the HTTP request via `Geolixir.HttpClient`.
  - Parsing the response from the specific provider's format.
  - Transforming the parsed data into the standardized `Geolixir.Result` struct.
  - Handling provider-specific errors and API key requirements.
  """

  alias Geolixir.Result

  @doc """
  Callback for geocoding a single address.

  ## Parameters
    - `payload`: A map containing the data needed for geocoding (e.g., `%{address: "..."}`).
    - `opts`: A keyword list of options, potentially including `:api_key` and provider-specific settings.

  ## Return Values
    - `{:ok, Result.t()}`: On success.
    - `{:error, reason}`: On failure.
  """
  @callback geocode(payload :: map(), opts :: keyword()) ::
              {:ok, Result.t()} | {:error, any()}

  @doc """
  Callback for geocoding a list of addresses (batch operation). Optional.

  ## Parameters
    - `payload`: A map containing the data needed for batch geocoding (e.g., `%{addresses: [...]}`).
    - `opts`: A keyword list of options.

  ## Return Values
    - `{:ok, list(Result.t())}`: On success.
    - `{:error, reason}`: On failure.
  """
  @callback geocode_list(payload :: map(), opts :: keyword()) ::
              {:ok, list(Result.t())} | {:error, any()}

  @doc """
  Callback for reverse geocoding a single pair of coordinates.

  ## Parameters
    - `payload`: A map containing the data needed for reverse geocoding (e.g., `%{lat: ..., lon: ...}`).
    - `opts`: A keyword list of options.

  ## Return Values
    - `{:ok, Result.t()}`: On success.
    - `{:error, reason}`: On failure.
  """
  @callback reverse_geocode(payload :: map(), opts :: keyword()) ::
              {:ok, Result.t()} | {:error, any()}

  @doc """
  Callback for reverse geocoding a list of coordinates (batch operation). Optional.

  ## Parameters
    - `payload`: A map containing the data needed for batch reverse geocoding (e.g., `%{coordinates: [%{lat: ..., lon: ...}, ...]}`).
    - `opts`: A keyword list of options.

  ## Return Values
    - `{:ok, list(Result.t())}`: On success.
    - `{:error, reason}`: On failure.
  """
  @callback reverse_geocode_list(payload :: map(), opts :: keyword()) ::
              {:ok, list(Result.t())} | {:error, any()}

  @optional_callbacks geocode_list: 2, reverse_geocode_list: 2
end

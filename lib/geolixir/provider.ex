defmodule Geolixir.Provider do
  @moduledoc """
  Behavior for geocoding providers.
  """

  @callback geocode(payload :: map(), opts :: keyword()) ::
              {:ok, Geolixir.Result.t()} | {:error, any()}

  @callback geocode_list(payload :: map(), opts :: keyword()) ::
              {:ok, list(Geolixir.Result.t())} | {:error, any()}

  @callback reverse_geocode(payload :: map(), opts :: keyword()) ::
              {:ok, Geolixir.Result.t()} | {:error, any()}

  @callback reverse_geocode_list(payload :: map(), opts :: keyword()) ::
              {:ok, list(Geolixir.Result.t())} | {:error, any()}

  @optional_callbacks geocode_list: 2, reverse_geocode_list: 2
end

defmodule Geolixir.Providers.Base do
  @moduledoc """
  Base module for geocoding providers with common functionality.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts, module: __MODULE__] do
      @behaviour Geolixir.Provider

      @endpoint Keyword.fetch!(opts, :endpoint)
      @search_path Keyword.fetch!(opts, :search_path)
      @reverse_path Keyword.fetch!(opts, :reverse_path)
      @query_word Keyword.get(opts, :query_word, "query_word")
      @before_compile module

      def geocode(payload, opts \\ []) do
        request(:geocode, payload, opts)
      end

      def geocode_list(payload, opts \\ []) do
        request(:geocode_list, payload, opts)
      end

      def reverse_geocode(payload, opts \\ []) do
        request(:reverse_geocode, payload, opts)
      end

      def reverse_geocode_list(payload, opts \\ []) do
        request(:reverse_geocode_list, payload, opts)
      end

      defoverridable geocode: 2, geocode_list: 2, reverse_geocode: 2, reverse_geocode_list: 2
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      defp request(_action, _payload, _opts) do
        raise "request/3 must be implemented by the provider"
      end

      defp build_result(_data) do
        raise "build_result/1 must be implemented by the provider"
      end
    end
  end
end

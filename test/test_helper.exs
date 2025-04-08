ExUnit.start()

# Copy mocks for Geolixir.HttpClient and HTTPoison
Mimic.copy(Geolixir.HttpClient)
Mimic.copy(HTTPoison)

defmodule Choobio.Tfl do
  @moduledoc """
  A service that interacts with TFL.
  """

  @tfl_all_stations_url "https://api.tfl.gov.uk/StopPoint/Type/NaptanMetroStation"
  @vsn "0"

  @doc """
  Retrieves every single tube station from TFL.

  WARNING: this will take a very long time, and is only supposed to be used
  if you need to get more data about stations from the TFL API when either
  spinning up a new DB, or perhaps launching a new feature that requires
  more data about a station than is currently stored in Choobio.
  """
  @callback retrieve_all_stations(url :: String.t) :: [%{}]
  def retrieve_all_stations(url \\ @tfl_all_stations_url) do
    IO.puts "Calling TFL for the list of stations..."
    call_tfl(url, [timeout: 50_000])
    |> decode_response()
  end

  # Private Functions

  defp call_tfl(url, opts) do
    url
    |> add_credentials
    |> HTTPotion.get(opts)
  end

  #TODO: this should take the api key and api id from mix.env
  defp add_credentials(url), do: url

  defp decode_response(%HTTPotion.Response{body: body}) do
    {:ok, list} = Poison.decode(body)
    list
  end

end
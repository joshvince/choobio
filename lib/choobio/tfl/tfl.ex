defmodule Choobio.Tfl do
  @moduledoc """
  A service that interacts with TFL.
  """

  @tfl_all_stations_url "https://api.tfl.gov.uk/StopPoint/Type/NaptanMetroStation"
  @tfl_all_lines_url "https://api.tfl.gov.uk/Line/Mode/tube"
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

  @callback retrieve_all_lines(url :: String.t) :: [%{}]
  def retrieve_all_lines(url \\ @tfl_all_lines_url) do
    IO.puts "Calling TFL for the list of lines..."
    call_tfl(url)
    |> decode_response()
  end

  @doc """
  TODO: doc this up!
  """
  @callback line_arrivals(station_id :: String.t, line_id :: String.t) :: String.t
  def line_arrivals(station_id, line_id) do
    "https://api.tfl.gov.uk/Line/#{line_id}/Arrivals?stopPointId=#{station_id}"
    |> call_tfl
  end

  @doc """
  Returns `true` if the response from TFL indicated success, false otherwise.
  """
  def successful_response?(response) do
    HTTPotion.Response.success?(response)
  end

  @doc """
  Helper function for grabbing only the body of an HTTP response.
  """
  def take_body(%HTTPotion.Response{body: body}), do: body

  # Private Functions

  defp call_tfl(url, opts \\ []) do
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

  # Parsing Functions

  @doc """
  Converts timestamp strings to `DateTime` structs, removing milliseconds.
  """
  @callback to_datetime(timestamp :: String.t) :: %DateTime{}
  def to_datetime(timestamp) do
    timestamp
    |> remove_ms
    |> add_timezone
    |> Timex.parse!("{ISO:Extended}")
  end

  defp remove_ms(timestamp) do
    case String.split(timestamp, ".") do
      [time, _ms] ->
        time
      [_time] ->
        timestamp
    end
  end

  defp add_timezone(string), do: "#{string}Z"

end
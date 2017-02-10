defmodule Commuter.Tfl do
  @moduledoc """
  Responsible for the interaction between the TFL API and the Commuter Service.

  Includes things like calling the actual API, all the way down to functions
  that parse the strings in time stamps.
  """
  use Timex

  @tfl_all_stations "https://api.tfl.gov.uk/StopPoint/Type/NaptanMetroStation"

  # Various helper functions for calling TFL and handling responses.

  @doc """
  All-purpose call to TFL using an HTTP client.

  Appends the app key and app ID to the url before making a get request to `url`.
  """
  def call_tfl(url) do
    url
    |> add_credentials
    |> HTTPotion.get
  end

  #TODO: this should take the api key and api id from mix.env
  defp add_credentials(url) do
    url
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

  # Application Set Up

  @doc """
  Makes a giant call to TFL to retrieve every single station on the network.

  This is a biggie, and will take A LONG TIME, which is why the timeout is so
  hideous. Also, because this is a unique call (it has to happen successfully
  in order for the app to start up) there is a checker function that retries
  an unsuccessful call.
  """
  def retrieve_all_stations(url \\ @tfl_all_stations) do
    IO.puts "Calling TFL for the list of stations..."
    HTTPotion.get(url, [timeout: 20_000])
    |> handle_response
    |> Poison.decode!([])
  end

  # I am not letting this crash like I should, because this call MUST
  # succeed for the appliation server to start.
  defp handle_response(%HTTPotion.ErrorResponse{} = res) do
    IO.puts("The call failed!")
    retrieve_all_stations
  end
  defp handle_response(successful_response), do: take_body(successful_response)

  # Arrival Data

  @doc """
  TODO: doc this up!
  """
  def line_arrivals(station_id, line_id) do
    "https://api.tfl.gov.uk/Line/#{line_id}/Arrivals?stopPointId=#{station_id}"
    |> call_tfl
  end

  # Parsing Functions

  # This is a really hacky way to get around the fact that (seemingly) timestamps

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
      [time] ->
        timestamp
    end
  end

  defp add_timezone(string), do: "#{string}Z"

end

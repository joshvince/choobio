defmodule Commuter.Tfl do
  @moduledoc """
  Responsible for the interaction between the TFL API and the Commuter Service.

  Includes things like calling the actual API, all the way down to functions
  that parse the strings in time stamps.
  """
  use Timex

  @doc """
  TODO: doc this up!
  """
  def call_station(station_id, line_id) do
    "https://api.tfl.gov.uk/Line/#{line_id}/Arrivals?stopPointId=#{station_id}"
    |> HTTPotion.get
    |> take_body
  end

  defp take_body(%HTTPotion.Response{body: body}), do: body

  #TODO: check that HTTPotion did not return an error

  # This is a really hacky way to get around the fact that (seemingly) timestamps
  # from TFL contain TOO MANY milliseconds for Timex library to handle.
  # :facepalm:

  @doc """
  TODO: doc this up!
  """
  def to_datetime(timestamp) do
    timestamp
    |> remove_ms
    |> add_timezone
    |> Timex.parse!("{ISO:Extended}")
  end

  defp remove_ms(timestamp) do
    [time, _ms] = String.split(timestamp, ".")
    time
  end

  defp add_timezone(string), do: "#{string}Z"

end

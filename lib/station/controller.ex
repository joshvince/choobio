defmodule Commuter.Station.Controller do
  @moduledoc """
  Handles client requests for station data.
  """
  alias Commuter.Train

  def return_arrivals(station_id, line_id, direction) do
    direction_atom = atomize_params(direction)

    atomize_params({station_id, line_id})
    |> Commuter.Station.get_arrivals
    |> take_direction(direction_atom)
    |> Poison.encode!
  end

  defp atomize_params({first, second}) do
    "#{first}_#{second}" |> String.to_atom
  end
  defp atomize_params(one_string), do: String.to_atom(one_string)

  defp take_direction(%Commuter.Station{} = station, direction) do
    Map.get(station, direction)
  end

  defp only_distance_in_seconds(list_of_trains) do
    list_of_trains
    |> Enum.map(fn %Train{time_to_station: time} -> "#{time} secs" end)
  end

end

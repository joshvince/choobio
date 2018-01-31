defmodule Choobio.Tfl.Initialiser do
  @moduledoc """
  Responsible for initialising a database with data from the TFL API.

  WARNING: you should only be running this when you need to re-populate the 
  DB, it includes insane calls to get literally all stations etc.
  """
  alias Choobio.{Station, Line}

  @tfl_api Application.get_env(:choobio, :tfl_api)

  def create_all_tube_stations() do
    retrieve_all_tube_stations()
    |> Enum.map( &create_station(&1) )
  end

  def create_all_tube_lines() do
    retrieve_all_lines()
    |> Enum.map( &create_line(&1) )
  end

  # Private Functions

  defp create_station(station) do
    Station.create_station(station)
  end

  defp create_line(line) do
    Line.create_line(line)
  end

  defp retrieve_all_tube_stations() do
    @tfl_api.retrieve_all_stations()
    |> find_only_tube_stations()
    |> Enum.map( &to_station_map(&1) )
  end

  defp retrieve_all_lines() do
    @tfl_api.retrieve_all_lines()
    |> Enum.map( &to_line_map(&1) )
  end

  defp find_only_tube_stations(list) do
    Enum.filter(list, &is_tube_station?(&1) )
  end

  defp is_tube_station?(map) do
    modes = map["modes"]
    Enum.member?(modes, "tube")
  end

  defp to_station_map(map) do
    %{name: map["commonName"], naptan_id: map["naptanId"]}
  end

  defp to_line_map(map) do
    %{name: map["name"], id: map["id"]}
  end
end
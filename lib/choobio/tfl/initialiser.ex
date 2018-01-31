defmodule Choobio.Tfl.Initialiser do
  @moduledoc """
  Responsible for initialising a database with data from the TFL API.

  WARNING: you should only be running this when you need to re-populate the 
  DB, it includes insane calls to get literally all stations etc.
  """
  alias Choobio.{Station, Line}

  @tfl_api Application.get_env(:choobio, :tfl_api)

  @doc """
  Initialises a database by calling TFL API and creating records in the
  database for each station and tube line.
  """
  def initialise() do
    create_all_tube_lines()
    create_all_tube_stations()
  end

  # Private Functions

  defp create_all_tube_stations() do
    retrieve_all_tube_stations()
    |> Enum.map( &create_station(&1) )
  end

  defp create_all_tube_lines() do
    retrieve_all_lines()
    |> Enum.map( &create_line(&1) )
  end

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
    %{  name: map["commonName"], naptan_id: map["naptanId"], 
        lines: getTubeIds(map["lineModeGroups"]) }
  end

  defp getTubeIds(list_of_lines) do
    list_of_lines
    |> Enum.find( fn(%{"modeName" => modeName}) -> modeName == "tube" end )
    |> take_ids()
  end

  defp take_ids(%{"lineIdentifier" => lines}), do: lines

  defp to_line_map(map) do
    %{name: map["name"], id: map["id"]}
  end
end
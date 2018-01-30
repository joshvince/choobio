defmodule Choobio.Tfl.Initialiser do
  @moduledoc """
  Responsible for initialising a database with data from the TFL API.

  WARNING: you should only be running this when you need to re-populate the 
  DB, it includes insane calls to get literally all stations etc.
  """
  alias Choobio.Station

  @tfl_api Application.get_env(:choobio, :tfl_api)

  def create_all_tube_stations() do
    retrieve_all_tube_stations()
    |> Enum.map( &create_station(&1) )
  end

  # Private Functions

  defp create_station(station) do
    Station.create_station(station)
  end

  defp retrieve_all_tube_stations() do
    @tfl_api.retrieve_all_stations()
    |> find_only_tube_stations()
    |> Enum.map( &take_relevant_data(&1) )
  end

  defp find_only_tube_stations(list) do
    Enum.filter(list, &is_tube_station?(&1) )
  end

  defp is_tube_station?(map) do
    modes = map["modes"]
    Enum.member?(modes, "tube")
  end

  defp take_relevant_data(map) do
    %{name: map["commonName"], naptan_id: map["naptanId"]}
  end
end
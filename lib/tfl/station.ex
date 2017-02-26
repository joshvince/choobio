defmodule Commuter.Tfl.Station do
  @moduledoc """
  Provides an API for getting station data provided by TFL.

  Use `find` to get one station based on an id, or `all` to get all of them.

  See docs for the other functions in this module for more details.
  """
  use GenServer

  @tfl_api Application.get_env(:commuter, :tfl_api)

  defstruct [:id, :name, :lines]

  # Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_all_stations do
    GenServer.call(__MODULE__, :get_all_stations)
  end

  def find_one_station(id) do
    GenServer.call(__MODULE__, {:find_one_station, id})
  end

  def get_arrivals(station_id, line_id) do
    GenServer.call(__MODULE__, {:get_arrivals, {station_id, line_id}})
  end

  # Server callbacks

  def init(:ok) do
    initial_state = create_station_list
    msg =
      "Initialised TFL Station list with #{inspect Enum.count(initial_state)} items"
    IO.puts msg
    {:ok, initial_state}
  end

  def handle_call(:get_all_stations, _from, station_list) do
    {:reply, station_list, station_list}
  end

  def handle_call({:find_one_station, id}, _from, station_list) do
    result = find_station(id, station_list)
    {:reply, result, station_list}
  end

  def handle_call({:get_arrivals, {station_id, line_id}}, _from, station_list) do
    arrivals = @tfl_api.line_arrivals(station_id, line_id)
    {:reply, arrivals, station_list}
  end

  # Application set up

  defp create_station_list do
    @tfl_api.retrieve_all_stations
    |> Enum.filter( &(is_tube_station?(&1)) )
    |> Enum.map( &(convert_to_struct(&1)) )
  end

  # Finding Stations

  defp find_station(given_id, station_list) do
    Enum.find(station_list, fn %Commuter.Tfl.Station{id: id} -> id == given_id end)
  end

  defp is_tube_station?(map) do
    modes = map["modes"]
    Enum.member?(modes, "tube")
  end

  defp convert_to_struct(map) do
    lines = find_lines(map)
    name = tidy_name(map["commonName"])
    id = map["naptanId"]
    %Commuter.Tfl.Station{id: id, name: name, lines: lines}
  end

  defp find_lines(map) do
    map["lineModeGroups"]
    |> Enum.find(fn map -> map["modeName"] == "tube" end)
    |> get_line_list
  end

  defp get_line_list(map) do
    map["lineIdentifier"]
  end

  defp tidy_name(string) do
    String.replace(string, ~r/ Underground Station/, "")
  end

end

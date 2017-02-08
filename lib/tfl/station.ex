defmodule Commuter.Tfl.Station do
  @moduledoc """
  Provides an API for getting station data provided by TFL.

  Use `find` to get one station based on an id, or `all` to get all of them.

  See docs for the other functions in this module for more details.
  """

  defstruct [:id, :name, :lines]

  @tfl_json "lib/tfl/all_stations.json"

  # Public API

  def find(id) do
    id
  end

  def all do
    "all!"
  end

  # Private functions for generating the data

  def load_structs(tfl_json \\ @tfl_json) do
    tfl_json
    |> load
    |> Poison.decode!
    |> Enum.map( fn map -> to_struct(map) end )
  end

  defp load(filepath) do
    {:ok, contents} = File.read(filepath)
    contents
  end

  defp to_struct(map) do
    %Commuter.Tfl.Station{id: map["naptanId"], name: map["stationName"], lines: []}
  end

  #TODO: get the lines for each station...

  def get_all_stations(url \\ "https://api.tfl.gov.uk/StopPoint/Type/NaptanMetroStation") do
    %HTTPotion.Response{body: body} =
      HTTPotion.get(url, [timeout: 20_000])
    body
    |> Poison.decode!
    |> Enum.filter( &(is_tube_station?(&1)) )
    |> Enum.map( &(convert_to_struct(&1)) )
  end

  defp is_tube_station?(map) do
    modes = map["modes"]
    Enum.member?(modes, "tube")
  end

  defp convert_to_struct(map) do
    lines = find_lines(map)
    name = map["commonName"]
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

end

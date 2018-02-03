defmodule Choobio.ChoobioTest do
  use Choobio.DataCase

  alias Choobio.{Line, Station}
  alias Choobio.Station.Platform
  alias Choobio.Station.Platform.Arrivals

  @station_id "940GZZLUTBC"
  @station_name "Tooting Bec"
  @line_id "northern"
  @process_name :"940GZZLUTBC_northern"
  @station_attrs %{name: "Tooting Bec", naptan_id: "940GZZLUTBC", lines: ["northern"]}
  @line_attrs %{name: "Northern", id: "northern"}

  def line_fixture(attrs \\ %{}) do
    {:ok, line} = 
      attrs
      |> Enum.into(@line_attrs)
      |> Line.create_line()

    line
  end

  def station_fixture(attrs \\ %{}) do
    {:ok, station} = 
      attrs
      |> Enum.into(@station_attrs)
      |> Station.create_station()

    station
  end

  test "list_stations/0 returns all stations" do
    line_fixture()
    station = station_fixture()
    [%{naptan_id: fetched_id}] = Choobio.list_stations()

    assert fetched_id == station.naptan_id
  end

  test "get_station/1 returns the station with the lines loaded" do
    line_fixture()
    station = station_fixture()
    
    assert Choobio.get_station(station.naptan_id) == station
  end

  test "get_arrivals/2 gets the arrivals from the given platform" do
    line_fixture()
    station_fixture()
    Platform.start_link(@station_id, @station_name, @line_id)
    reply = Platform.get_arrivals(@process_name)

    assert reply.__struct__ == Platform
    assert reply.arrivals.__struct__ == Arrivals
  end
end
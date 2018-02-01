defmodule Choobio.Station.Platform.ArrivalsTest do
  use ExUnit.Case
  alias Choobio.Station.Platform.Arrivals
  alias Choobio.Line.Train

  setup do
    trains =
      Choobio.Tfl.Mock.line_arrivals(:test)
      |> Train.create_train_structs
    %{trains: trains}
  end

  test "builds an arrivals struct", %{trains: trains} do
    assert Arrivals.build_arrivals(trains).__struct__ == Arrivals
  end

  test "raw lists are just lists of train structs", %{trains: trains} do
    arr = Arrivals.build_arrivals(trains)
    assert Enum.all?(arr.inbound.trains, fn struct ->
      assert struct.__struct__ == Train end)
    assert Enum.all?(arr.outbound.trains, fn struct ->
      assert struct.__struct__ == Train end)
  end

  test "trains going in both directions are put in the right list", %{trains: trains} do
    arr = Arrivals.build_arrivals(trains)
    refute Enum.count(arr.inbound.trains) == 0
    refute Enum.count(arr.outbound.trains) == 0
    Enum.all?(arr.inbound.trains, fn struct ->
      assert struct.direction.canonical == "inbound" end)
    Enum.all?(arr.outbound.trains, fn struct ->
      assert struct.direction.canonical == "outbound" end)
  end

  test "trains are ordered chronologically by arrival time", %{trains: trains} do
    list = Arrivals.build_arrivals(trains).outbound.trains
    arrival_times = Enum.map(list, fn map -> map.time_to_station end)
    sorted_arrival_times = Enum.sort(arrival_times)
    assert arrival_times == sorted_arrival_times
  end

  test "intervals are inserted correctly.", %{trains: trains} do
    [one, two] = Arrivals.build_arrivals(trains).outbound.trains |> Enum.take(2)
    assert two.interval == (two.time_to_station - one.time_to_station)
  end

  test "both lists have proper *bound names", %{trains: trains} do
    arr = Arrivals.build_arrivals(trains)
    assert arr.inbound.name == "Northbound" || "Southbound"
  end

end
defmodule Choobio.StationTest do
  use Choobio.DataCase

  alias Choobio.Station

  describe "stations" do
    alias Choobio.{Station, Line}

    @valid_attrs %{name: "some name", lines: ["northern"], naptan_id: "940GZZLUTBC"}
    @invalid_attrs %{name: nil, lines: [], naptan_id: "FAKR"}

    setup do
      Line.create_line(%{id: "northern", name: "Northern"})
      {:ok, %{}}
    end

    def station_fixture(attrs \\ %{}) do
      {:ok, station} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Station.create_station()
        
      station
    end

    test "list_stations/0 returns all stations" do
      station = station_fixture()

      [listed_naptan_id] = 
        Station.list_stations()
        |> Enum.map(fn %{naptan_id: id} -> id end)
      
      assert listed_naptan_id == station.naptan_id
    end

    test "get_station!/1 returns the station with given id" do
      station = station_fixture()

      %{naptan_id: naptan_id} = Station.get_station!(station.naptan_id)
      assert naptan_id == station.naptan_id
    end

    test "create_station/1 with valid data creates a station" do
      assert {:ok, %Station{} = station} = Station.create_station(@valid_attrs)
      assert station.name == "some name"
    end

    test "create_station/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Station.create_station(@invalid_attrs)
    end

  end
end
defmodule Choobio.ArrivalsTest do
  use Choobio.DataCase

  alias Choobio.Arrivals

  describe "stations" do
    alias Choobio.Arrivals.Station

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def station_fixture(attrs \\ %{}) do
      {:ok, station} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Arrivals.create_station()

      station
    end

    test "list_stations/0 returns all stations" do
      station = station_fixture()
      assert Arrivals.list_stations() == [station]
    end

    test "get_station!/1 returns the station with given id" do
      station = station_fixture()
      assert Arrivals.get_station!(station.id) == station
    end

    test "create_station/1 with valid data creates a station" do
      assert {:ok, %Station{} = station} = Arrivals.create_station(@valid_attrs)
      assert station.name == "some name"
    end

    test "create_station/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arrivals.create_station(@invalid_attrs)
    end

    test "update_station/2 with valid data updates the station" do
      station = station_fixture()
      assert {:ok, station} = Arrivals.update_station(station, @update_attrs)
      assert %Station{} = station
      assert station.name == "some updated name"
    end

    test "update_station/2 with invalid data returns error changeset" do
      station = station_fixture()
      assert {:error, %Ecto.Changeset{}} = Arrivals.update_station(station, @invalid_attrs)
      assert station == Arrivals.get_station!(station.id)
    end

    test "delete_station/1 deletes the station" do
      station = station_fixture()
      assert {:ok, %Station{}} = Arrivals.delete_station(station)
      assert_raise Ecto.NoResultsError, fn -> Arrivals.get_station!(station.id) end
    end

    test "change_station/1 returns a station changeset" do
      station = station_fixture()
      assert %Ecto.Changeset{} = Arrivals.change_station(station)
    end
  end
end

defmodule ChoobioWeb.StationControllerTest do
  use ChoobioWeb.ConnCase

  alias Choobio.Arrivals
  alias Choobio.Arrivals.Station

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:station) do
    {:ok, station} = Arrivals.create_station(@create_attrs)
    station
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all stations", %{conn: conn} do
      conn = get conn, station_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  defp create_station(_) do
    station = fixture(:station)
    {:ok, station: station}
  end
end

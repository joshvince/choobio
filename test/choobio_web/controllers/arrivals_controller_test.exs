defmodule ChoobioWeb.ArrivalsControllerTest do
  use ChoobioWeb.ConnCase
  alias Choobio.{Line, Station}
  alias Choobio.Station.Platform

  @station_id "940GZZLUTBC"
  @station_name "Tooting Bec"
  @line_id "northern"
  @station_attrs %{name: "Tooting Bec", naptan_id: "940GZZLUTBC", lines: ["northern"]}
  @line_attrs %{name: "Northern", id: "northern"}

  defp line_fixture(attrs \\ %{}) do
    {:ok, line} = 
      attrs
      |> Enum.into(@line_attrs)
      |> Line.create_line()

    line
  end

  defp station_fixture(attrs \\ %{}) do
    {:ok, station} = 
      attrs
      |> Enum.into(@station_attrs)
      |> Station.create_station()

    station
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET arrivals/:station/:line" do
    test "returns arrivals for the given station and line", %{conn: conn} do
      line_fixture()
      station_fixture()
      Platform.start_link(@station_id, @station_name, @line_id)
      conn = get conn, "/api/arrivals/#{@station_id}/#{@line_id}"

      assert json_response(conn, 200)["data"]["arrivals"]
    end
  end

end
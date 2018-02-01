defmodule ChoobioWeb.StationController do
  use ChoobioWeb, :controller

  alias Choobio.Station

  action_fallback ChoobioWeb.FallbackController

  def index(conn, _params) do
    stations = Station.list_stations()
    render(conn, "index.json", stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Station.get_station!(id)
    render(conn, "show.json", station: station)
  end
end
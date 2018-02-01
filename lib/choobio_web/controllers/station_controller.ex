defmodule ChoobioWeb.StationController do
  use ChoobioWeb, :controller

  action_fallback ChoobioWeb.FallbackController

  def index(conn, _params) do
    stations = Choobio.list_stations()
    render(conn, "index.json", stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Choobio.get_station!(id)
    render(conn, "show.json", station: station)
  end
end
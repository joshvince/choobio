defmodule ChoobioWeb.StationController do
  use ChoobioWeb, :controller

  alias Choobio.Arrivals
  alias Choobio.Arrivals.Station

  action_fallback ChoobioWeb.FallbackController

  def index(conn, _params) do
    stations = Arrivals.list_stations()
    render(conn, "index.json", stations: stations)
  end

  def show(conn, %{"id" => id}) do
    station = Arrivals.get_station!(id)
    render(conn, "show.json", station: station)
  end

end

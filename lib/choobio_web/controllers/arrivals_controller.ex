defmodule ChoobioWeb.ArrivalsController do
  use ChoobioWeb, :controller

  action_fallback ChoobioWeb.FallbackController

  def show(conn, %{"station_id" => station_id, "line_id" => line_id}) do
    with {:ok, arrivals} <- Choobio.get_arrivals(station_id, line_id) do
      render(conn, "show.json", arrivals: arrivals)
    end
  end
end
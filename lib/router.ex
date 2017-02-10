defmodule Commuter.Router do
  use Plug.Router

  require Logger

  alias Commuter.Station.Controller

  plug Plug.Logger
  plug :match
  plug :dispatch

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(Commuter.Router, [])
  end

  def init(opts) do
    opts
  end

  get "/" do
    conn
    |> send_resp(200, "OK")
    |> halt
  end

  get "/stations/:station_id/:line_id/:direction" do
    arrivals =
      Commuter.Station.Controller.return_arrivals(station_id, line_id, direction)
    conn
    |> send_resp(200, arrivals)
  end

  match _ do
    IO.inspect(conn.params)
    send_resp(conn, 404, "oops!")
  end

end

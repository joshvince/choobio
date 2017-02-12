defmodule Commuter.Router do
  use Plug.Router

  require Logger

  alias Commuter.Station.Controller

  plug Plug.Logger
  plug :match
  plug :dispatch

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(Commuter.Router, [], Application.get_env(:port))
  end

  def init(opts) do
    IO.puts "SYS PORT was #{inspect System.get_env("PORT")}"
    IO.puts "Plug was passed Port #{Application.get_env(:port)}"
    opts
  end

  get "/" do
    conn
    |> send_resp(200, "OK")
    |> halt
  end

  get "/stations/:station_id/:line_id/:direction" do
    Controller.get_arrivals(conn)
  end

  match _ do
    IO.inspect(conn.params)
    send_resp(conn, 404, "oops!")
  end

end

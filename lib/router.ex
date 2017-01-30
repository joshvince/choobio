defmodule Commuter.Router do
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug :match
  plug :dispatch

  def init(opts) do
    opts
  end

  get "/" do
    conn
    |> send_resp(200, "OK")
    |> halt
  end

  match _ do
    IO.inspect(conn.params)
    send_resp(conn, 404, "oops!")
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http Commuter.Router, []
  end
end

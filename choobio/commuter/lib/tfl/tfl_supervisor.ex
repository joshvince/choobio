defmodule Commuter.Tfl.TflSupervisor do
  use Supervisor
  def start_link do
    children = [
      worker(Commuter.Tfl.Station, [])
    ]

    opts = [strategy: :one_for_one, name: TflSupervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end
end

defmodule Commuter.Station.StationSupervisor do
  use Supervisor
  def start_link(station_id) do
    #TODO: this shouldn't actually be hardcoded in...
    line_id = "northern"

    children = [
      worker(Commuter.Station, [station_id, line_id])
    ]

    opts = [strategy: :one_for_one, name: StationSupervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end
end

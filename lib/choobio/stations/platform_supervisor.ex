defmodule Choobio.Station.PlatformSupervisor do
  use Supervisor
  alias Choobio.{Station,Line}

  def start_link do
    children = Station.get_all_stations() |> create_all_workers()
    opts = [strategy: :one_for_one, name: PlatformSupervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end

  def init(:ok) do
    {:ok, []}
  end

  defp create_all_workers(list_of_stations) do
    list_of_stations
    |> Enum.map( &(create_platform_workers(&1)) )
    |> List.flatten
  end

  defp create_platform_workers(%Station{lines: lines, naptanId: station_id, name: name}) do
    Enum.map(lines, fn %Line{line_id: line_id} ->
      create_worker(station_id, name, line_id) end )
  end

  defp create_worker(station_id, station_name, line_id) do
    pname = create_process_name(station_id, line_id)
    worker(Choobio.Station.Platform, [station_id, station_name, line_id], [id: pname])
  end

  defp create_process_name(station_id, line_id) do
    "#{station_id}_#{line_id}" |> String.to_atom
  end
end

defmodule Commuter.Station.StationSupervisor do
  use Supervisor

  def start_link do
    station_list = Commuter.Tfl.Station.get_all_stations
    children = create_all_workers(station_list)

    opts = [strategy: :one_for_one, name: StationSupervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end

  defp create_all_workers(list_of_stations) do
    list_of_stations
    |> Enum.map( &(create_line_workers(&1)) )
    |> List.flatten
  end

  defp create_line_workers(%Commuter.Tfl.Station{lines: lines} = station) do
    Enum.map(lines, &(create_worker(station.id, &1)) )
  end

  defp create_worker(station_id, line_id) do
    pname = create_process_name(station_id, line_id)
    worker(Commuter.Station, [station_id, line_id], [id: pname])
  end

  defp create_process_name(station_id, line_id) do
    "#{station_id}_#{line_id}" |> String.to_atom
  end
end

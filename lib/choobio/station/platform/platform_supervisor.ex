defmodule Choobio.Station.Platform.PlatformSupervisor do
  use Supervisor
  alias Choobio.Station
  alias Choobio.Station.Platform

  def start_link() do
    children =
      Station.list_stations(:lines)
      |> create_all_workers()

    opts = [strategy: :one_for_one, name: PlatformSupervisor]
    {:ok, _pid} = Supervisor.start_link(children, opts)
  end

  def init(:ok), do: {:ok, []}

  defp create_all_workers(list_of_stations) do
    list_of_stations
    |> Enum.map( &(create_line_workers(&1)) )
    |> List.flatten
  end

  defp create_line_workers(%Station{lines: lines} = station) do
    lines
    |> Enum.map(fn %{id: line_id} -> 
        create_worker(station.naptan_id, station.name, line_id) 
      end)
  end

  defp create_worker(station_id, station_name, line_id) do
    pname = create_process_name(station_id, line_id)
    worker(Platform, [station_id, station_name, line_id], [id: pname])
  end

  defp create_process_name(station_id, line_id) do
    "#{station_id}_#{line_id}" |> String.to_atom
  end
end
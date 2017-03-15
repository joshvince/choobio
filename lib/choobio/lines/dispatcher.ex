defmodule Choobio.Line.Dispatcher do
  @moduledoc """
  Receives messages from TFL about trains and passes the data on to the relevant
  train process, creating a new one if necessary.
  """
  use Supervisor

  def start_link(line_id) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Choobio.Train, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def find_or_create_train({vehicle_id, line_id}) do
    if train_process_exists?({vehicle_id, line_id}) do
      {:ok, vehicle_id}
    else
      create_train_process({vehicle_id, line_id})
    end
  end

  def train_process_exists?({vehicle_id, line_id}) do
    registry = get_registry_name(line_id)
    case Registry.lookup(registry, vehicle_id) do
      [] -> false
      _ -> true
    end
  end

  def create_train_process({vehicle_id, line_id}) do
    case Supervisor.start_child(__MODULE__, [{vehicle_id, line_id}]) do
      {:ok, pid} ->
        {:ok, vehicle_id}
      {:error, {:already_started, _pid}} ->
        {:error, :process_already_exists}
      other ->
        {:error, other}
    end
  end

  def train_process_count do
    Supervisor.which_children(__MODULE__) |> Enum.count
  end

  def get_registry_name(line_id) do
    String.to_atom("#{line_id}_registry")
  end

end

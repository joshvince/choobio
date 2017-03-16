defmodule Choobio.Line.Dispatcher do
  @moduledoc """
  Receives messages from TFL about trains and passes the data on to the relevant
  train process, creating a new one if necessary.
  """
  use Supervisor

  # Initialisation

  def start_link(line_id) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [worker(Choobio.Train, [])]
    supervise(children, strategy: :simple_one_for_one)
  end

  # Dispatching to trains

  @doc """
  Used to lookup a train process using its vehicle and line identifiers.

  If the process already exists, returns `{:ok, ID}`.

  If the process doesn't already exist, it creates it with the given `vehicle_id`
  and will register it in the registry.
  """
  def find_or_create_train({vehicle_id, line_id}) do
    if train_process_exists?({vehicle_id, line_id}) do
      {:ok, vehicle_id}
    else
      create_train_process({vehicle_id, line_id})
    end
  end

  @doc """
  Returns true if a train process already exists under supervision by this module,
  false otherwise.
  """
  def train_process_exists?({vehicle_id, line_id}) do
    registry = get_registry_name(line_id)
    case Registry.lookup(registry, vehicle_id) do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Creates and Supervises a train process. See `Choobio.Train` for the details on
  exactly what it is creating.

  Will return error tuples if the process already exists, or any other reason.
  """
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

  # Helper Functions

  @doc """
  Counts number of train processes currently supervised.
  """
  def train_process_count do
    Supervisor.which_children(__MODULE__) |> Enum.count
  end

  @doc """
  Shortcut to getting the registry name.
  """
  defp get_registry_name(line_id) do
    String.to_atom("#{line_id}_registry")
  end

end

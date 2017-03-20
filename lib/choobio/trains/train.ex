defmodule Choobio.Train do
	require Logger
  @moduledoc """
  When started under a supervision tree, like `Choobio.Line.Supervisor`, this module
  creates a genserver representing one train on the network.

  The functionality here is all around holding state about where the train is, and
  how long it has had its doors open for throughout its journey.

  When the process is started, it can send and receive messages to receive
  data from TFL via a `Dispatcher`.
  """
  use GenServer
  alias __MODULE__, as: Train

	defstruct [:id, :location, :next_station, :time_to_station]

  @doc """
  Starts a train process and registers its name in the registry relating to `line_id`.

  A train that receives `{"001", "northern"}` will be registered in `:northern_registry`
  under the key "001".
  """
	def start_link({vehicle_id, line_id}) do
		initial_data = %{id: vehicle_id}
		name = via_tuple({vehicle_id, line_id})
		{:ok, _} = GenServer.start_link(__MODULE__, initial_data, name: name)
	end

  # Public API

  @doc """
  Returns the process ID of a train process, or nil if it doesn't exist in this
  registry.

  The registry is specific to the line, based on `line_id` given to this function.
  """
  def whereis({vehicle_id, line_id}) do
    registry = get_registry_name(line_id)
    case Registry.lookup(registry, vehicle_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  @doc """
  Returns the current location of the train
  """
	def get_location({vehicle_id, line_id}) do
		GenServer.call(via_tuple({vehicle_id, line_id}), :get_location)
	end

  @doc """
  Updates the process state with the new location data, which has presumably
  arrived via `Dispatcher` from TFL.
  """
	def update_location({vehicle_id, line_id}, new_data) do
		GenServer.cast(via_tuple({vehicle_id, line_id}), {:update_location, new_data})
	end

  # Genserver

  @doc """
  See `&get_location/1` for details
  """
	def handle_call(:get_location, _from, state) do
		{:reply, state, state}
	end

  @doc """
  See `&update/2` for details
  """
	def handle_cast({:update_location, new_data}, state) do
		new_state = update_location_data(new_data, state)
		now = DateTime.utc_now()
		Logger.info "\n#{now.hour}:#{now.minute}:#{now.second} :: #{inspect new_state}\n"
		{:noreply, new_state}
	end

  # Private functions

	defp update_location_data(%Choobio.Tfl.Arrival{} = new_data, old_location) do
		%{old_location |
			:next_station => new_data.naptanId,
			:location => new_data.currentLocation,
			:time_to_station => new_data.timeToStation}
	end

  @doc """
  Used to register the process name under its vehicle ID in the registry.

  See `&start_link/1` for more details.
  """
  def via_tuple({vehicle_id, line_id}) do
    registry = get_registry_name(line_id)
    {:via, Registry, {registry, vehicle_id}}
  end

  @doc """
  Initialises the process with a basic location map.
  """
  def init(data) do
    state = %Train{id: data.id}
    {:ok, state}
  end

  defp get_registry_name(line_id) do
    String.to_atom("#{line_id}_registry")
  end

end

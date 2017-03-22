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

	defstruct [	:id, :location, :next_station, :time_to_station,
							:direction, :line_id, :expected_arrival,
							at_platform: %{currently: nil, ticks: 0, total_ticks: 0}]

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

	def arrived_at_platform(pid, state) do
		GenServer.cast(pid, {:at_platform, state})
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
		check_for_arrival(state, new_state)
	end

	#TODO: this!!
	def handle_cast({:at_platform, new_state}, state) do
		{:noreply, new_state}
	end

	@doc """
	Used to register the process name under its vehicle ID in the registry.
	See `&start_link/1` for more details.
	"""
	def via_tuple({vehicle_id, line_id}) do
		registry = get_registry_name(line_id)
		{:via, Registry, {registry, vehicle_id}}
	end

	defp get_registry_name(line_id), do: String.to_atom("#{line_id}_registry")

	@doc """
	Initialises the process with a basic location map.
	"""
	def init(data) do
		state = %Train{id: data.id}
		{:ok, state}
	end

# Private functions

	defp update_location_data(%Choobio.Tfl.Arrival{} = new_data, old_location) do
		%{old_location |
			:next_station => new_data.naptanId, :location => new_data.currentLocation,
			:time_to_station => new_data.timeToStation, :expected_arrival => new_data.expectedArrival,
			:direction => new_data.direction, :line_id => new_data.lineId}
	end

	# the train hasn't arrived at a station yet (because the next_station is still the same)
	defp check_for_arrival(%Train{next_station: same} = old, %Train{next_station: same} = new_state) do
		{:noreply, new_state}
	end
	# the train has arrived at a platform, because the next station has changed.
	defp check_for_arrival(old_state, new_data) do
		updated_map = %{old_state.at_platform | :currently => old_state.next_station, :ticks => 1}
		new_state = %{new_data | :at_platform => updated_map}
		# cast out to at_platform (send to self())
		arrived_at_platform(self(), new_state)
		# return the new state
		{:noreply, new_state}
	end

end

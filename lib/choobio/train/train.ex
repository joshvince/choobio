defmodule Choobio.Train do
  use GenServer
  alias __MODULE__, as: Train
  alias Choobio.Tfl


	def start_link(vehicle_id, starting_location, next_station) do
		pname = String.to_atom(vehicle_id)
		init_args = {vehicle_id, starting_location, next_station}
		{:ok, _} = GenServer.start_link(__MODULE__, init_args, name: pname)
	end

	def init({vehicle_id, location, station}) do
		state = %{id: vehicle_id, location: location, next_station: station}
		{:ok, state}
	end

	def get_location(process_name) do
		GenServer.call(process_name, :get_location)
	end

	def update(process_name, new_data) do
		GenServer.cast(process_name, {:update_location, new_data})
	end

	def handle_call(:get_location, _from, state) do
		{:reply, state, state}
	end

	def handle_cast({:update_location, new_data}, state) do
		new_state = update_location(new_data, state)
		now = DateTime.utc_now()
		IO.puts "\n#{now.hour}:#{now.minute}:#{now.second} :: #{inspect new_state}\n"
		{:noreply, new_state}
	end

	defp update_location(new_data, old_location) do
		new_loc = Map.get(new_data, :location)
		new_stat = Map.get(new_data, :station)
		old_location
		|> Map.put(:next_station, new_stat)
		|> Map.put(:location, new_loc)
	end

end

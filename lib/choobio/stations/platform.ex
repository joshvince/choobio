defmodule Choobio.Station.Platform do
	require Logger
	use GenServer
  alias __MODULE__, as: Platform

  defstruct [:station_id, :station_name, :line_id, :arrivals, :timestamp]

  @doc """
  Used to start a supervised process. Registers the name in the :platform_registry.

	The process will be registered under :"naptanId_lineId" like
	```
  :"906ULZBLH_northern"
  ```
  Station ID and line ID are both passed to the `init` function.
  """
  def start_link(station_id, station_name, line_id) do
    GenServer.start_link(__MODULE__, {{station_id, line_id}, station_name}, name: via_tuple({station_id, line_id}))
  end

	@doc """
	Used to register the process name under its vehicle ID in the registry.
	See `&start_link/1` for more details.
	"""
	def via_tuple({station_id, line_id}) do
		pname = create_process_name(station_id, line_id)
		{:via, Registry, {:platform_registry, pname}}
	end

  defp create_process_name(station_id, line_id) do
    "#{station_id}_#{line_id}" |> String.to_atom
  end

	# Public API

  def get_arrivals({station_id, line_id}) do
    GenServer.call(via_tuple({station_id, line_id}), :get_arrivals)
  end

	def new_arrival({station_id, line_id}, train_data) do
		GenServer.call(via_tuple({station_id, line_id}), {:new_arrival, train_data})
	end


  # Server callbacks

  def init({{station_id, line_id}, station_name}) do
    initial_state =
      %Platform{station_id: station_id, line_id: line_id, station_name: station_name}
    {:ok, initial_state}
  end

  #NOTE: temp while we set the scaffold up.

  def handle_call(:get_arrivals, _from, %Platform{} = state) do
		Logger.info "Arrivals for #{state.station_name}: #{inspect state.arrivals}"
    {:reply, state.arrivals, state}
  end

	def handle_call({:new_arrival, train_data}, _from, %Platform{} = state) do
		new_state = update_arrival(state, train_data)
		{:reply, new_state, new_state}
	end

	defp update_arrival(%Platform{} = state, train_data) do
		Map.put(state, :arrivals, train_data)
	end

end

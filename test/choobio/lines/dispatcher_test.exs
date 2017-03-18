defmodule Choobio.Line.DispatcherTest do
	use ExUnit.Case
	alias Choobio.Line.Dispatcher

	@tfl_api Application.get_env(:choobio, :tfl_api)



	setup do
		# start the Line Supervisor and the registry
		{:ok, pid} = Choobio.Line.Supervisor.start_link "northern"
		# get the arrivals data from the mock tfl api
	  resp = @tfl_api.get_all_arrivals("northern")
		{:ok, api_resp: resp, sup_pid: pid}
	end

	test "returns tuples of the id and a struct for that train's next arrival", %{sup_pid: sup} do
		list = Dispatcher.get_arrivals_data("northern")
		Enum.each(list, fn {id, %Choobio.Tfl.Arrival{} = struct} ->
			assert id == struct.vehicleId
		end)

		GenServer.stop(sup)
	end

	test "creates or dispatches to a process for each vehicle", %{api_resp: resp, sup_pid: sup} do
		Dispatcher.update_all_arrivals("northern")
		assert Dispatcher.train_process_count == Enum.count(resp)

		GenServer.stop(sup)
	end

	test "updates train data based on data supplied", %{api_resp: api_resp, sup_pid: sup} do
		Dispatcher.update_all_arrivals("northern")
		location_data = List.first(api_resp)
		train = Choobio.Train.get_location({location_data.vehicleId, "northern"})

		assert train.next_station == location_data.naptanId
		assert train.location == location_data.currentLocation
		assert train.time_to_station == location_data.timeToStation

		GenServer.stop(sup)
	end

end

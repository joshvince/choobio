defmodule Choobio.TrainTest do
	use ExUnit.Case
	alias Choobio.{Train, Station, Line}

	setup do
		# start the registry for the platform
		Registry.start_link(:unique, :platform_registry)
		# start a platform
		Station.Platform.start_link("940GZZLUGGN", "Golders Green Underground Station", "northern")
		{:ok, %{}}
	end

	test "train is created with initial state of just the vehicle ID" do
		# start the supervisor the line
		Line.Supervisor.start_link "northern"
		# start a train
		Train.start_link({"002", "northern"})
		%Train{id: id} = Train.get_location({"002", "northern"})
		assert id == "002"
	end

	test "trains approaching a station send a message to the platform" do
		# start a the line Supervisor
		{:ok, sup} = Line.Supervisor.start_link "northern"
		# update the arrivals
		Line.Dispatcher.update_all_arrivals "northern"
		response = Station.Platform.get_arrivals({"940GZZLUGGN", "northern"})
		assert response.id == "127"
		assert response.next_station == "940GZZLUGGN"

		GenServer.stop(sup)
	end

end

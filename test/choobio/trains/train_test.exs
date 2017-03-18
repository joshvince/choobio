defmodule Choobio.TrainTest do
	use ExUnit.Case
	alias Choobio.Train

	setup do
		# start the Line Supervisor and the registry
		{:ok, sup_pid} = Choobio.Line.Supervisor.start_link "TrainTest"
	  {:ok, %{supervisor_pid: sup_pid}}
	end

	test "train is creating with initial state of just the vehicle ID", %{supervisor_pid: sup} do
		{:ok, _pid} = Train.start_link({"002", "TrainTest"})
		%Train{id: id} = Train.get_location({"002", "TrainTest"})
		assert id == "002"

	end

end

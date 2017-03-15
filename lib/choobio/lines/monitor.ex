defmodule Choobio.Line.Monitor do
	alias Choobio.{Train,Tfl}

	def schedule_calls(id, pid) do
		:timer.apply_interval(30000, __MODULE__, :get_and_update, [id, pid])
	end

	def get_and_update(id, pid) do
		get_new_data_from_tfl(id)
		|> call_train(pid)
	end

	def get_new_data_from_tfl(id) do
		get_trains
		|> find_train(id)
	end

	def call_train(new_data, pid) do
		Train.update(pid, new_data)
	end

	def get_trains do
    Tfl.get_all_arrivals
    |> Enum.map(fn x ->
      %{location: x["currentLocation"], station: x["naptanId"],
        time_to_arrival: x["timeToStation"], vehicle_id: x["vehicleId"],
        platform_name: x["platformName"]} end)
    |> by_train
  end

  defp by_train(list) do
    Enum.reduce(list, %{}, &group_by_train/2)
  end

  defp group_by_train(el, acc) do
    Map.update(acc, el.vehicle_id, [el], &add_to_list(&1, el))
  end

  defp add_to_list(list, el) do
    [el | list] |> by_next_station
  end

	defp by_next_station(train_list) do
		train_list
		|> Enum.sort(fn a,b -> a.time_to_arrival < b.time_to_arrival end)
	end

	defp find_train(trains, vehicle_id) do
		[el] = Map.get(trains, vehicle_id) |> Enum.take(1)
		el
	end
end

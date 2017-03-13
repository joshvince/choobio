defmodule Choobio.Train do
  use GenServer
  alias __MODULE__, as: Train
  alias Choobio.Tfl

  def get_trains do
    Tfl.get_all_arrivals
    |> Enum.map(fn x ->
      %{"location" => x["currentLocation"], "station" => x["naptanId"],
        "timeToArrival" => x["timeToStation"], "vehicleId" => x["vehicleId"],
        "platformName" => x["platformName"]} end)
    |> by_train
  end

  def by_train(list) do
    Enum.reduce(list, %{}, &group_by_train/2)
  end

  defp group_by_train(el, acc) do
    Map.update(acc, el["vehicleId"], [el], &add_to_location_list(&1, el))
  end

  defp add_to_location_list(list, el) do
    location = el["location"]
    [location | list]
  end

  def by_station(list) do
    Enum.reduce(list, %{}, &group_by_station/2)
  end

  defp group_by_station(el, acc) do
    Map.update(acc, el["station"], [el], &add_to_list(&1, el))
  end

  defp add_to_list(list, el) do
    [el | list]
  end

  def track_train(vehicle_id) do
    get_trains
    |> Enum.find(fn x -> x["vehicleId"] == vehicle_id end)
    |> take_location
    # |> IO.puts
  end

  def northbound?(map) do
    [dir | _rest] = String.split(map["platformName"], " ")
    dir == "Northbound"
  end

  def take_location(train) do
    train["location"]
  end

end

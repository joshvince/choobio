defmodule Commuter.Train do
  @enforce_keys [:arrival_time, :location, :destination, :train_id, :direction]

  defstruct [:arrival_time, :time_to_station, :location, :train_id, :direction,
              destination: %{destination_name: nil, destination_id: nil},
             :interval]

  alias __MODULE__, as: Train

  @tfl_api Application.get_env(:commuter, :tfl_api)

  @doc """
  Converts a string representing a JSON array of objects into Train Structs.
  """
  def create_train_structs(string) do
    string
    |> Poison.decode!
    |> Enum.map( &(map_to_struct(&1)) )
  end

  defp map_to_struct(map) do
    %Train{
      location: map["currentLocation"],
      arrival_time: @tfl_api.to_datetime(map["expectedArrival"]),
      time_to_station: map["timeToStation"],
      destination: %{
        destination_name: map["destinationName"],
        destination_id: map["destinationNaptanId"]
      },
      train_id: map["vehicleId"],
      direction: map["direction"]
    }
  end



end

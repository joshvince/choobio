defmodule Choobio.Line.Train do
  @enforce_keys [:arrival_time, :location, :destination, :train_id]

  defstruct [ :arrival_time, :time_to_station, :location, :train_id, :interval,
              direction: %{canonical: nil, name: nil},
              destination: %{destination_name: nil, destination_id: nil}]

  alias __MODULE__, as: Train

  @tfl_api Application.get_env(:choobio, :tfl_api)

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
        destination_name: tidy_name(map["destinationName"]),
        destination_id: map["destinationNaptanId"]
      },
      train_id: map["vehicleId"],
      direction: %{
        canonical: map["direction"],
        name: directionName(map["platformName"])
      }
    }
  end

  # Sometimes trains end up with no destination.
  defp tidy_name(nil), do: "Check front of train"
  defp tidy_name(string), do: String.replace(string, ~r/ Underground Station/, "")

  defp directionName(string) do
    # ~r/\w*bound\b/
    # \w*bound\b
    Regex.run(~r/\w*bound\b/, string)
    |> getMatch(string)
  end
  
  defp getMatch(nil, string), do: string
  defp getMatch([match | _rest], string), do: match

end
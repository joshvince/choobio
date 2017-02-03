defmodule Commuter.Train.Arrivals do
  defstruct [:station_id, :line_id, :timestamp, inbound: [], outbound: []]
  alias Commuter.{Train,Tfl}
  alias Commuter.Train.Arrivals

  @tooting "940GZZLUTBC"
  @line "northern"

  def start(station_id, line_id) do
    init = initialise(station_id, line_id)
    Task.start_link(fn -> listen(init) end)
  end

  def initialise(station_id, line_id) do
    %Arrivals{station_id: station_id, line_id: line_id}
    |> get_arrivals
  end

  #TODO: this!
  # need to listen out for :get requests
  # when one arrives, check the cached timestamp vs the current time
  # if it's more than 60 seconds, go fetch a new arrival time and return it
  # otherwise, return the cached data to the client
  defp listen(%Arrivals{} = cache) do
    # receive do
    #   {:get, line_id, caller} ->
    #     send caller, Map.get(map, line_id)
    #     listen(map)
    #   {:put, line_id, times} ->
    #     Map.put(map, line_id, times)
    #     |> listen
    # end
  end

  @doc """
  Given a station id and a line id, calls TFL for arrivals at the given station
  on the given line and returns a timestamped `Arrivals` struct containing
  trains expected at the given station, on the given line.

  The struct contains two lists (:inbound and :outbound) of Train structs. For
  details on a train struct, see the `Commuter.Train` module.
  """
  def get_arrivals(%Arrivals{station_id: station, line_id: line} = struct) do
    Tfl.call_station(station, line)
    |> create_train_structs
    |> update_arrivals_struct(struct)
  end

  defp create_train_structs(string) do
    string
    |> Poison.decode!
    |> Enum.map( &(to_train_struct(&1)) )
  end

  defp to_train_struct(map) do
    %Train{
      location: map["currentLocation"],
      arrival_time: Tfl.to_datetime(map["expectedArrival"]),
      destination: %{
        destination_name: map["destinationName"],
        destination_id: map["destinationNaptanId"]
      },
      train_id: map["vehicleId"],
      direction: map["direction"]
    }
  end

  defp update_arrivals_struct(train_structs, arrivals_struct) do
    train_structs
    |> Enum.reduce(arrivals_struct, &(into_direction(&1, &2)))
    |> sort_by_distance
    |> insert_timestamp
  end

  defp into_direction(%Train{direction: "inbound"} = map, %Arrivals{inbound: current} = acc) do
    new_list = [map | current]
    %{acc | inbound: new_list}
  end

  defp into_direction(%Train{direction: "outbound"} = map, %Arrivals{outbound: current} = acc) do
    new_list = [map | current]
    %{acc | outbound: new_list}
  end

  defp into_direction(_another_map, acc), do: acc

  defp sort_by_distance(%Arrivals{inbound: inb, outbound: outb} = map) do
    %{ map |
    inbound: sort_chronologically(inb),
    outbound: sort_chronologically(outb)
    }
  end

  def sort_chronologically(list) do
    Enum.sort(list, &by_arrival_time/2 )
  end

  defp by_arrival_time(struct1, struct2) do
    Timex.before?(struct1.arrival_time, struct2.arrival_time)
  end

  defp insert_timestamp(%Arrivals{} = map) do
    %{map | timestamp: Timex.now}
  end

end

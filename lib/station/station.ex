defmodule Commuter.Station do
  use GenServer

  alias Commuter.{Train}
  alias __MODULE__, as: Station

  defstruct [:station_id, :line_id, timestamp: Timex.zero,
            inbound: [], outbound: []]

  @tfl_api Application.get_env(:commuter, :tfl_api)

  # Client API

  @doc """
  Used to start a supervised process. Gives itself a name which is the result of
  atomising `station_id` and `line_id` separated by an underscore.

  ```
  :"906ULZBLH_northern"
  ```

  Station ID and line ID are both passed to the `init` function.
  """
  def start_link(station_id, line_id) do
    pname = create_process_name(station_id, line_id)
    GenServer.start_link(__MODULE__, {station_id, line_id}, name: pname)
  end

  @doc """
    Returns arrival lists of trains by fetching data from the TFL API.

    Data is considered 'fresh' up to 60 seconds' lag. This is to avoid hammering
    the TFL API. If the cached timestamp is less than 60 seconds ago, the cached
    data will be returned.

    Otherwise, new data is fetched from TFL, converted to lists of train structs
    and sorted by time of arrival.

    For details on a train struct, see the `Commuter.Train` module.
  """
  def get_arrivals(process_name) do
    GenServer.call(process_name, :get_arrivals)
  end

  # Server callbacks

  def init({station_id, line_id}) do
    IO.puts "Arrivals board is starting up for station #{station_id}"
    initial_state = %Station{station_id: station_id, line_id: line_id}
    {:ok, initial_state}
  end

  def handle_call(:get_arrivals, _from, %Station{} = state) do
    result = fetch_arrivals(state)
    {:reply, result, result}
  end

  # Helper functions

  defp create_process_name(station_id, line_id) do
    "#{station_id}_#{line_id}" |> String.to_atom
  end

  # Business Logic

  defp fetch_arrivals(%Station{} = state) do
    check_time_elapsed(state.timestamp)
    |> return_arrivals(state)
  end

  defp check_time_elapsed(cached_time) do
    diff = Timex.diff(Timex.now, cached_time, :seconds)
    cond do
      diff < 60 ->
        :use_cache
      true ->
        :use_fresh
    end
  end

  defp return_arrivals(:use_cache, %Station{} = cache), do: cache
  defp return_arrivals(:use_fresh, %Station{} = cache) do
    attempt_tfl_call(cache)
  end

  defp attempt_tfl_call(%Station{} = cache) do
    response = @tfl_api.line_arrivals(cache.station_id, cache.line_id)
    case @tfl_api.successful_response?(response) do
      false ->
        cache
      true ->
        @tfl_api.take_body(response) |> create_cache(cache)
    end
  end

  defp create_cache(http_response_body, %Station{} = cache) do
    new_struct = %Station{station_id: cache.station_id, line_id: cache.line_id}
    http_response_body
    |> create_train_structs
    |> build_arrivals_struct(new_struct)
  end

  defp create_train_structs(string) do
    string
    |> Poison.decode!
    |> Enum.map( &(to_train_struct(&1)) )
  end

  defp to_train_struct(map) do
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

  defp build_arrivals_struct(train_structs, %Station{} = empty_struct) do
    train_structs
    |> Enum.reduce(empty_struct, &(into_direction(&1, &2)))
    |> sort_by_distance
    |> insert_timestamp
  end

  defp into_direction(%Train{direction: "inbound"} = map, %Station{inbound: current} = acc) do
    new_list = [map | current]
    %{acc | inbound: new_list}
  end

  defp into_direction(%Train{direction: "outbound"} = map, %Station{outbound: current} = acc) do
    new_list = [map | current]
    %{acc | outbound: new_list}
  end

  defp into_direction(_another_map, acc), do: acc

  defp sort_by_distance(%Station{inbound: inb, outbound: outb} = map) do
    %{ map |
    inbound: sort_chronologically(inb),
    outbound: sort_chronologically(outb)
    }
  end

  defp sort_chronologically(list) do
    Enum.sort(list, &by_arrival_time/2 )
  end

  defp by_arrival_time(struct1, struct2) do
    Timex.before?(struct1.arrival_time, struct2.arrival_time)
  end

  defp insert_timestamp(%Station{} = map) do
    %{map | timestamp: Timex.now}
  end

end

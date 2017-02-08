defmodule Commuter.Station do
  use GenServer

  alias Commuter.{Train,Tfl}
  alias __MODULE__, as: Station

  defstruct [:station_id, :line_id, timestamp: Timex.zero,
            inbound: [], outbound: []]

  @tooting "940GZZLUTBC"
  @line "northern"

  # Client API

  def start_link(station_id, line_id) do
    # pname = create_process_name(station_id, line_id)
    GenServer.start_link(__MODULE__, {station_id, line_id}, name: __MODULE__)
  end

  def get_arrivals do
    GenServer.call(__MODULE__, :get_arrivals)
  end

  # Server callbacks

  def init({station_id, line_id}) do
    IO.puts "Station board is starting up for station #{station_id}"
    initial_state = %Station{station_id: station_id, line_id: line_id}
    {:ok, initial_state}
  end

  def handle_call(:get_arrivals, _from, %Station{} = state) do
    result = get_arrivals(state)
    {:reply, result, result}
  end

  # Helper functions

  defp create_process_name(station_id, line_id) do
    "#{station_id}_#{line_id}" |> String.to_atom
  end

  # Business Logic

  @doc """
    This code is executed when a request arrives to the process - the first
    step is to check how long has elapsed since the last response was cached
    (the cache is passed to this function.) If it was made less than 60 seconds
    ago, the cache will be returned unaltered.

    If it was longer than 60 seconds ago, then this function calls TFL and
    updates the cache struct based on the latest arrivals expected at the given
    station and line.

    The returned Station struct will contain lists of `Train` structs going
    `inbound` and `outbound` for the given line from the given station
    (these two pieces of data are assumed to be already present in the struct.)

    For details on a train struct, see the `Commuter.Train` module.
  """
  defp get_arrivals(%Station{} = state) do
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
    response = Tfl.call_station(cache.station_id, cache.line_id)
    case HTTPotion.Response.success?(response) do
      false ->
        cache
      true ->
        take_body(response) |> create_cache(cache)
    end
  end

  defp take_body(%HTTPotion.Response{body: body}), do: body

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
      arrival_time: Tfl.to_datetime(map["expectedArrival"]),
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

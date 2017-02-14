defmodule Commuter.Station.Arrivals do
  @moduledoc """
  Handles functionality for arrivals data. This data has already been parsed from
  TFL-json to Train structs, and generally ends up being returned as an Arrivals
  struct.
  """
  defstruct [inbound: %{raw: [], calculated: []},
             outbound: %{raw: [], calculated: []}]
  alias Commuter.{Station, Train}
  alias __MODULE__, as: Arrivals

  ##

  #TODO: this should operate only on an arrivals struct, rather than a station.

  ##

  def build_arrivals(train_structs) do
    %Arrivals{}
    |> build_raw(train_structs)
    # |> build_calculated
  end

  defp build_raw(%Arrivals{} = arrivals, train_structs) do
    arrivals
    |> put_into_direction_list(train_structs)
    |> sort_train_lists
    # |> sort_by_distance
  end

  defp put_into_direction_list(%Arrivals{} = arrivals, train_structs) do
    Enum.reduce(train_structs, arrivals, &(into_direction(&1,&2)))
  end

  defp into_direction(%Train{direction: "inbound"} = train, %Arrivals{} = acc) do
    new_map = %{raw: [train | acc.inbound.raw], calculated: []}
    %{acc | inbound: new_map}
  end

  defp into_direction(%Train{direction: "outbound"} = train, %Arrivals{} = acc) do
    new_map = %{raw: [train | acc.outbound.raw], calculated: []}
    %{acc | outbound: new_map}
  end

  defp sort_by_distance(%Arrivals{} = struct) do
    inb = sort_chronologically(struct.inbound.raw)
    outb = sort_chronologically(struct.outbound.raw)
    %{struct |  inbound: %{raw: inb, calculated: []},
                outbound: %{raw: outb, calculated: []}}
  end

  defp sort_train_lists(%Arrivals{inbound: inb_map, outbound: outb_map} = struct) do

  end

  defp sort_chronologically_with_interval(list) do
    list
    |> sort_chronologically
    |> insert_intervals
  end

  defp sort_chronologically(list) do
    Enum.sort(list, &by_arrival_time/2 )
  end

  defp by_arrival_time(struct1, struct2) do
    Timex.before?(struct1.arrival_time, struct2.arrival_time)
  end

  ## psuedo:
  # take in a list of train structs.
  # For each of them, take in the previous train's time to the station, and the
  # current train struct.
  # Work out the difference between the previous train and the current train's time
  # to station. Insert that into the train struct, add the struct to the accumulator
  # and then return the accumulator.


  def insert_intervals(list) do
    insert_intervals(0, list)
  end

  defp insert_intervals(prev, [last | []]) do
    calculate_interval(prev, last)
  end

  defp insert_intervals(prev, [current | tail]) do
    res = calculate_interval(prev, current)
    [res | insert_intervals(res.time_to_station, tail)]
  end

  defp calculate_interval(prev, %Train{time_to_station: t} = struct) do
    diff = t - prev
    %{struct | interval: diff}
    # Map.put(map, :diff, diff)
  end

  # OLD NEW STUFF....




  def build_one_calculated_list(list_of_trains) do
    list_of_trains
    |> with_intervals
    |> ignore_next_train
    |> take_top_three
  end

  defp with_intervals(list_of_trains) do
    list_of_trains
    |> get_interval
    |> Enum.reverse
  end

  defp get_interval([first | rest]) do
    init = [{first.time_to_station, first}]
    Enum.reduce(rest, init, &get_interval(&1, &2))
  end

  defp get_interval(current, [{distance, _struct} | _rest] = acc) do
    interval = (current.time_to_station - distance)
    [{interval, current} | acc]
  end

  # TODO: this and below... It's not working right now.

  # Because we don't know how soon after the last train the next train is,
  # We ignore it - unless there's only one train in total.
  defp ignore_next_train([next_train | rest]), do: rest
  defp ignore_next_train([only_one_train | []]), do:  only_one_train

  defp take_top_three([first | rest]) do
    rest
    |> sort_by_shortest_interval
    |> Enum.slice(0,3)
  end

  defp sort_by_shortest_interval(list_of_tuples) when is_list(list_of_tuples) do
    list_of_tuples
    |> Enum.sort(fn {i1, map1}, {i2, map2} -> i1 < i2 end)
  end

  defp sort_by_shortest_interval(tuple), do: [tuple]





  ##

  #OLD FUNCTIONS - can be deleted when there is arrivals struct versions of them.

  ##

  def build_arrivals_struct(train_structs, %Station{} = empty_struct) do
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

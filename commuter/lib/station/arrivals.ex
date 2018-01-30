defmodule Commuter.Station.Arrivals do
  @moduledoc """
  Handles functionality for arrivals data. This data has already been parsed from
  TFL-json to Train structs, and ends up being returned as an Arrivals struct.
  """
  defstruct [inbound: %{trains: [], name: "Inbound"}, outbound: %{trains: [], name: "Outbound"}]
  alias Commuter.{Train}
  alias __MODULE__, as: Arrivals

  def build_arrivals(train_structs) do
    %Arrivals{}
    |> put_into_direction_list(train_structs)
    |> sort_train_lists
    |> add_direction_strings
  end

  defp put_into_direction_list(%Arrivals{} = arrivals, train_structs) do
    Enum.reduce(train_structs, arrivals, &(into_direction(&1,&2)))
  end

  defp into_direction(%Train{direction: %{canonical: "inbound"}} = train, %Arrivals{} = acc) do
    %{acc | inbound: add_to_train_list(acc.inbound, train)}
  end

  defp into_direction(%Train{direction: %{canonical: "outbound"}} = train, %Arrivals{} = acc) do
    %{acc | outbound: add_to_train_list(acc.outbound, train)}
  end

  defp into_direction(%Train{} = train, %Arrivals{} = acc), do: acc

  defp add_to_train_list(map, new_train) do
    Map.update!(map, :trains, &([new_train | &1]) )
  end

  defp sort_train_lists(%Arrivals{inbound: inb_map, outbound: outb_map} = struct) do
    new_inb = sort_train_list_chronologically(inb_map)
    new_outb = sort_train_list_chronologically(outb_map)
    %{struct | inbound: new_inb, outbound: new_outb}
  end

  defp sort_train_list_chronologically(map) do
    Map.update!(map, :trains, &(sort_chronologically_with_interval(&1)) )
  end

  defp sort_chronologically_with_interval(list) do
    list
    |> sort_chronologically
    |> insert_intervals
    |> Enum.reverse
  end

  defp sort_chronologically(list) do
    Enum.sort(list, &by_arrival_time/2 )
  end

  defp by_arrival_time(struct1, struct2) do
    Timex.before?(struct1.arrival_time, struct2.arrival_time)
  end

  defp insert_intervals(list_of_trains) do
    {_, result} = Enum.reduce(list_of_trains, {0, []}, &calculate_interval/2)
    result
  end

  defp calculate_interval(%Train{time_to_station: time} = struct, {prev_time, list}) do
    interval = (time - prev_time)
    {time, [%{struct | interval: interval} | list]}
  end

  defp add_direction_strings(%Arrivals{inbound: inb, outbound: outb} = arrivals) do
    new_inb = assign_name(inb)
    new_outb = assign_name(outb)
    %{arrivals | inbound: new_inb, outbound: new_outb}
  end

  defp assign_name(map) do
    grab_first_train_direction(map.trains)
    |> add_to_name(map)
  end

  defp grab_first_train_direction([]), do: :not_found
  defp grab_first_train_direction(train_list) do
    %Train{direction: %{name: direction_name}} = List.first(train_list)
    direction_name
  end

  defp add_to_name(:not_found, map), do: map
  defp add_to_name(direction_string, map) do
    Map.put(map, :name, direction_string)
  end

end

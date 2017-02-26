defmodule Commuter.Station.Arrivals do
  @moduledoc """
  Handles functionality for arrivals data. This data has already been parsed from
  TFL-json to Train structs, and ends up being returned as an Arrivals struct.
  """
  defstruct [inbound: [], outbound: []]
  alias Commuter.{Train}
  alias __MODULE__, as: Arrivals

  def build_arrivals(train_structs) do
    %Arrivals{}
    |> put_into_direction_list(train_structs)
    |> sort_train_lists
  end

  defp put_into_direction_list(%Arrivals{} = arrivals, train_structs) do
    Enum.reduce(train_structs, arrivals, &(into_direction(&1,&2)))
  end

  defp into_direction(%Train{direction: "inbound"} = train, %Arrivals{} = acc) do
    %{acc | inbound: [train | acc.inbound]}
  end

  defp into_direction(%Train{direction: "outbound"} = train, %Arrivals{} = acc) do
    %{acc | outbound: [train | acc.outbound]}
  end

  defp into_direction(%Train{} = train, %Arrivals{} = acc), do: acc

  defp sort_train_lists(%Arrivals{inbound: inb_list, outbound: outb_list} = struct) do
    new_inb = sort_chronologically_with_interval(inb_list)
    new_outb = sort_chronologically_with_interval(outb_list)
    %{struct | inbound: new_inb, outbound: new_outb}
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

end

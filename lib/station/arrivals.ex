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

  end

  defp build_raw(%Arrivals{} = arrivals, train_structs) do
    arrivals
    |> put_into_direction_list(train_structs)
    |> sort_by_distance
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

  defp sort_chronologically(list) do
    Enum.sort(list, &by_arrival_time/2 )
  end

  defp by_arrival_time(struct1, struct2) do
    Timex.before?(struct1.arrival_time, struct2.arrival_time)
  end



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

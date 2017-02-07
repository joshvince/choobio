defmodule Commuter.Station.ArrivalsTest do
  use ExUnit.Case, async: true
  alias Commuter.Station.Arrivals

  setup do
    {:ok, arrival_board} = Arrivals.start_link
    {:ok, arrival_board: arrival_board}
  end

  test "returns a struct with two lists of trains",
  %{arrival_board: arrival_board} do
    result = Arrivals.get_arrivals(arrival_board)
    %Arrivals{inbound: inbound_list, outbound: outbound_list} = result
    assert is_list(inbound_list) && is_list(outbound_list)
  end

  test "the trains are all assigned to the correct direction's list",
  %{arrival_board: arrival_board} do
    result = Arrivals.get_arrivals(arrival_board)
    Enum.each(result.inbound, fn %Commuter.Train{direction: direction} ->
      assert direction == "inbound" end)
    Enum.each(result.outbound, fn %Commuter.Train{direction: direction} ->
      assert direction == "outbound" end)
  end




end

defmodule Commuter.Station.StationTest do
  use ExUnit.Case, async: true
  alias Commuter.Station

  @process_id :"940GZZLUTBC_northern"

  test "returns a struct containing an arrivals struct" do
    result = Station.get_arrivals(@process_id)
    %Station{arrivals: arrivals} = result
    assert arrivals.__struct__ == Commuter.Station.Arrivals
  end

end

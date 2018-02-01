defmodule Choobio.Station.PlatformTest do
  use ExUnit.Case, async: true
  alias Choobio.Station.Platform

  @station_id "940GZZLUTBC"
  @station_name "Tooting Bec"
  @line_id "northern"
  @process_id :"940GZZLUTBC_northern"

  setup_all do
    Platform.start_link(@station_id, @station_name, @line_id)
    {:ok, process_id: @process_id}
  end

  test "returns a struct containing an arrivals struct", %{process_id: pid} do
    result = Platform.get_arrivals(pid)
    %Platform{arrivals: arrivals} = result
    assert arrivals.__struct__ == Choobio.Station.Platform.Arrivals
  end

end
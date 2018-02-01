defmodule Choobio.Station.PlatformTest do
  use ExUnit.Case, async: true
  alias Choobio.Station.Platform

  @process_id :"940GZZLUTBC_northern"

  test "returns a struct containing an arrivals struct" do
    result = Platform.get_arrivals(@process_id)
    %Platform{arrivals: arrivals} = result
    assert arrivals.__struct__ == Choobio.Station.Platform.Arrivals
  end

end
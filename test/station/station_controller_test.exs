defmodule Commuter.Station.ControllerTest do
  use ExUnit.Case

  alias Commuter.Station.Controller

  @tooting "940GZZLUTBC"
  @northern "northern"
  @direction "inbound"

  test "returns a list of train structs" do
    result = Controller.return_arrivals(@tooting, @northern, @direction)
    assert is_list(result)
    
  end
end

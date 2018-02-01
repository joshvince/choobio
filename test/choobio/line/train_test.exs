defmodule Choobio.Line.TrainTest do
  use ExUnit.Case
  alias Choobio.Line.Train

  setup do
    response = Choobio.Tfl.Mock.line_arrivals(:test)
    %{string: response}
  end

  test "only returns *bound as the direction", %{string: string} do
    res = Train.create_train_structs(string)
    Enum.all?(res, fn map ->
      assert map.direction.name == "Northbound" || assert map.direction.name == "Southbound"
    end)
  end

end
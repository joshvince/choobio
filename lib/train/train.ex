defmodule Commuter.Train do
  @enforce_keys [:arrival_time, :location, :destination, :train_id, :direction]

  defstruct [
    :arrival_time,
    :location,
    :train_id,
    :direction,
    destination: %{
      destination_name: nil,
      destination_id: nil
    }
  ]


end

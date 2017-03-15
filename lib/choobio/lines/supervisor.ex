defmodule Choobio.Line.Supervisor do
  @moduledoc """
  Supervises the creation of processes associated with a Tube Line.
  Starts the following processes:

  - A `Dispatcher` to receive messages from TFL, create train processes and update
  them with that data.
  - A `Registry` to hold information about the train processes.
  """
  use Supervisor
  alias Choobio.Line.Dispatcher

  def start_link(line_id) do
    registry_name = String.to_atom("#{line_id}_registry")
    children = [
      supervisor(Registry, [:unique, registry_name]),
      supervisor(Dispatcher, [line_id])
    ]

    opts = [strategy: :one_for_one, name: LineSupervisor]
    Supervisor.start_link(children, opts)
  end

end

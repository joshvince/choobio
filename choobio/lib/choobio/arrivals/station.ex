defmodule Choobio.Arrivals.Station do
  use Ecto.Schema
  import Ecto.Changeset
  alias Choobio.Arrivals.Station


  schema "stations" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Station{} = station, attrs) do
    station
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

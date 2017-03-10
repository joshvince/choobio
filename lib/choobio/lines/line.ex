defmodule Choobio.Line do
  @moduledoc """
  Handles the creation of Line models for insertion into the DB.
  """
  use Ecto.Schema
  alias __MODULE__, as: Line

  schema "lines" do
    field :name, :string
    field :line_id, :string
    many_to_many :stations, Choobio.Station, join_through: "lines_stations"

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name, :line_id])
  end

  def create(params) do
    changeset(%Line{}, params)
    |> Choobio.Repo.insert!
    |> Choobio.Repo.preload(:stations)
  end

end

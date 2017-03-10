defmodule Choobio.Station do
  @moduledoc """
  Handles the creation of station models for insertion into the DB.
  """
  use Ecto.Schema
  alias __MODULE__, as: Station

  schema "stations" do
    field :name, :string
    field :naptanId, :string
    many_to_many :lines, Choobio.Line, join_through: "lines_stations"

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name, :naptanId])
    |> Ecto.Changeset.put_assoc(:lines, get_lines(params.lines))
  end

  def get_lines(line_ids) do
    Enum.map(line_ids, &Choobio.Repo.get_by(Choobio.Line, line_id: &1))
  end

  # Stations are only created when the seeds are ran.
  def create(params) do
    changeset(%Station{}, params)
    |> Choobio.Repo.insert!
  end

end

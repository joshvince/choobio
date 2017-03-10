defmodule Choobio.Station do
  @moduledoc """
  Handles the creation of, and interaction with, station models in the DB.
  """
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias __MODULE__, as: Station
  alias Choobio.Repo
  
  schema "stations" do
    field :name, :string
    field :naptanId, :string
    many_to_many :lines, Choobio.Line, join_through: "lines_stations"

    timestamps()
  end

  # Application Setup

  # Stations are only created when the seeds are ran.
  def create(params) do
    changeset(%Station{}, params)
    |> Repo.insert!
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:name, :naptanId])
    |> Ecto.Changeset.put_assoc(:lines, get_lines(params.lines))
  end

  defp get_lines(line_ids) do
    Enum.map(line_ids, &Repo.get_by(Choobio.Line, line_id: &1))
  end

  # API for Platforms

  def get_all_stations do
    Repo.all(Station)
    |> Repo.preload(:lines)
  end

  def get_one_station(natpan_id) do
    Repo.get_by(Station, naptanId: natpan_id)
    |> Repo.preload(:lines)
  end

end

defmodule Choobio.Line do
  use Ecto.Schema
  import Ecto.Changeset
  alias Choobio.Line
  alias Choobio.Repo

  @primary_key {:id, :string, autogenerate: false}

  schema "lines" do
    field :name, :string
    many_to_many :stations, Choobio.Station, 
      [ join_through: "stations_lines", 
      join_keys: [line_id: :id, station_naptan_id: :naptan_id] ]

    timestamps()
  end

  def list_lines do
    Repo.all(Line)
  end

  def get_line!(id), do: Repo.get!(Line, id)

  def create_line(attrs \\ %{}) do
    %Line{}
    |> Line.changeset(attrs)
    |> Repo.insert()
  end

  def delete_line(%Line{} = line) do
    Repo.delete(line)
  end

  @doc false
  def changeset(%Line{} = line, attrs) do
    line
    |> cast(attrs, [:name, :id])
    |> validate_required([:name, :id])
  end
end
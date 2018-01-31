defmodule Choobio.Station do
  use Ecto.Schema
  import Ecto.Changeset
  alias Choobio.Station
  alias Choobio.Repo

  @primary_key {:naptan_id, :string, autogenerate: false}

  schema "stations" do
    field :name, :string
    many_to_many :lines, Choobio.Line, 
      [ join_through: "stations_lines", 
        join_keys: [station_naptan_id: :naptan_id, line_id: :id] ]
  
    timestamps()
  end

  @doc """
  Returns the list of stations.
  """
  def list_stations do
    Repo.all(Station)
  end

  @doc """
  Gets a single station.

  Raises `Ecto.NoResultsError` if the Station does not exist.
  """
  def get_station!(naptan_id), do: Repo.get!(Station, naptan_id)

  @doc """
  Creates a station.

  ## Examples

      iex> create_station(%{field: value})
      {:ok, %Station{}}

      iex> create_station(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_station(attrs \\ %{}) do
    lines = Enum.map(attrs.lines, &Choobio.Line.get_line!(&1))
    
    %Station{}
    |> Station.changeset(attrs)
    |> put_assoc(:lines, lines)
    |> Repo.insert()
  end

  @doc """
  Updates a station.

  ## Examples

      iex> update_station(station, %{field: new_value})
      {:ok, %Station{}}

      iex> update_station(station, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_station(%Station{} = station, attrs) do
    station
    |> Station.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Station.
  """
  def delete_station(%Station{} = station) do
    Repo.delete(station)
  end

  @doc false
  def changeset(%Station{} = station, attrs) do
    station
    |> cast(attrs, [:name, :naptan_id])
    |> validate_required([:name, :naptan_id])
  end
end

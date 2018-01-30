defmodule Choobio.Station do
  use Ecto.Schema
  import Ecto.Changeset
  alias Choobio.Station
  alias Choobio.Repo


  schema "stations" do
    field :name, :string
    field :naptan_id, :string
  
    timestamps()
  end

  @doc """
  Returns the list of stations.

  ## Examples

      iex> list_stations()
      [%Station{}, ...]

  """
  def list_stations do
    Repo.all(Station)
  end

  @doc """
  Gets a single station.

  Raises `Ecto.NoResultsError` if the Station does not exist.

  ## Examples

      iex> get_station!(123)
      %Station{}

      iex> get_station!(456)
      ** (Ecto.NoResultsError)

  """
  def get_station!(id), do: Repo.get!(Station, id)

  @doc """
  Creates a station.

  ## Examples

      iex> create_station(%{field: value})
      {:ok, %Station{}}

      iex> create_station(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_station(attrs \\ %{}) do
    %Station{}
    |> Station.changeset(attrs)
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

  ## Examples

      iex> delete_station(station)
      {:ok, %Station{}}

      iex> delete_station(station)
      {:error, %Ecto.Changeset{}}

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

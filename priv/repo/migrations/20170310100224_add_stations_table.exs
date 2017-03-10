defmodule Choobio.Repo.Migrations.AddStationsTable do
  use Ecto.Migration

  def change do
    create table(:stations) do
      add :name, :string
      add :naptanId, :string

      timestamps()
    end

    create unique_index(:stations, [:naptanId])
  end
end

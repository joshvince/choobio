defmodule Choobio.Repo.Migrations.CreateStations do
  use Ecto.Migration

  def change do
    create table(:stations) do
      add :name, :string
      add :naptan_id, :string
      timestamps()
    end

  end
end

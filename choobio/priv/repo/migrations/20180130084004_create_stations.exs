defmodule Choobio.Repo.Migrations.CreateStations do
  use Ecto.Migration

  def change do
    create table(:stations) do
      add :name, :string

      timestamps()
    end

  end
end

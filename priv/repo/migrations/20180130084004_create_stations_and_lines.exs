defmodule Choobio.Repo.Migrations.CreateStationsAndLines do
  use Ecto.Migration

  def change do
    create table(:stations, primary_key: false) do
      add :name, :string
      add :naptan_id, :string, primary_key: true

      timestamps()
    end

    create table(:lines, primary_key: false) do
      add :name, :string
      add :id, :string, primary_key: true

      timestamps()
    end

    create table(:stations_lines) do
      add(:station_naptan_id, 
          references(:stations, [column: :naptan_id, type: :string]))
      add :line_id, references(:lines, [type: :string])
    end

  end
end

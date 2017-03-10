defmodule Choobio.Repo.Migrations.LinesStations do
  use Ecto.Migration

  def change do
    create table(:lines_stations, primary_key: false) do
      add :line_id, references(:lines)
      add :station_id, references(:stations)
    end
  end
end

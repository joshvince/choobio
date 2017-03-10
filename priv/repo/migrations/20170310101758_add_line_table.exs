defmodule Choobio.Repo.Migrations.AddLineTable do
  use Ecto.Migration

  def change do
    create table(:lines) do
      add :name, :string
      add :line_id, :string

      timestamps()
    end

    create unique_index(:lines, [:line_id])
  end
end

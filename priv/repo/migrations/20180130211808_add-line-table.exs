defmodule :"Elixir.Choobio.Repo.Migrations.Add-line-table" do
  use Ecto.Migration

  def change do
    create table(:lines, primary_key: false) do
      add :name, :string
      add :id, :string, primary_key: true

      timestamps()
    end

  end
end

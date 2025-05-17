defmodule Spectrumed.Repo.Migrations.CreateTraits do
  use Ecto.Migration

  def change do
    create table(:traits) do
      add :description, :text
      add :bullets, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end

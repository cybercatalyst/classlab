defmodule Classlab.Repo.Migrations.CreateMaterial do
  use Ecto.Migration

  def change do
    create table(:materials) do
      add :visible, :boolean, default: false, null: false
      add :name, :string, null: false
      add :type, :integer, null: false
      add :contents, :map
      add :event_id, references(:events, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:materials, [:event_id])
    create unique_index(:materials, [:event_id, :name])
  end
end

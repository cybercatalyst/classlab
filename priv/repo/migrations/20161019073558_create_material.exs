defmodule Classlab.Repo.Migrations.CreateMaterial do
  use Ecto.Migration

  def change do
    create table(:materials) do
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :type, :integer, null: false
      add :description, :text, null: false
      add :position, :integer, null: false
      add :title, :string, null: false
      add :url, :string, null: false
      timestamps()
    end
    create index(:materials, [:event_id])
  end
end

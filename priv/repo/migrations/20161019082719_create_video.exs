defmodule Classlab.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :description, :text, null: false
      add :position, :integer, null: false
      add :title, :string, null: false
      add :url, :string, null: false
      timestamps()
    end
    create index(:videos, [:event_id])

  end
end

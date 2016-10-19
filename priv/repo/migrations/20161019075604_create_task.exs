defmodule Classlab.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :body, :text, null: false
      add :bonus, :text
      add :external_app_url, :string
      add :hint, :text
      add :position, :integer, null: false
      add :title, :string, null: false
      timestamps()
    end
    create index(:tasks, [:event_id])
  end
end

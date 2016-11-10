defmodule Classlab.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :body_markdown, :text, null: false
      add :bonus_markdown, :text
      add :external_app_url, :string
      add :hint_markdown, :text
      add :position, :integer, null: false
      add :title, :string, null: false
      add :unlocked_at, :datetime
      timestamps()
    end
    create index(:tasks, [:event_id])
    create unique_index(:tasks, [:position, :event_id])
  end
end

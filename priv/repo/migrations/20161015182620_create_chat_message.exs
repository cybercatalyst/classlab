defmodule Classlab.Repo.Migrations.CreateChatMessage do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :body, :text, null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nilify_all)
      timestamps()
    end
    create index(:chat_messages, [:event_id])
    create index(:chat_messages, [:user_id])
  end
end

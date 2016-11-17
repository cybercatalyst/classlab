defmodule Classlab.Repo.Migrations.CreateFeedback do
  use Ecto.Migration

  def change do
    create table(:feedbacks) do
      add :content_rating, :integer, null: false, default: 1
      add :content_comment, :text
      add :trainer_rating, :integer, null: false, default: 1
      add :trainer_comment, :text
      add :location_rating, :integer, null: false, default: 1
      add :location_comment, :text
      add :testimonial, :text
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      timestamps()
    end
    create index(:feedbacks, [:event_id])
    create index(:feedbacks, [:user_id])
    create unique_index(:feedbacks, [:user_id, :event_id], name: :feedbacks_user_id_event_id_index)
  end
end

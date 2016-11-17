defmodule Classlab.Repo.Migrations.CreateMembership do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :event_id, references(:events, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :nothing), null: false
      add :seat_position_x, :integer, null: false, default: 0
      add :seat_position_y, :integer, null: false, default: 0
      add :before_email_sent_at, :datetime
      add :after_email_sent_at, :datetime
      timestamps()
    end
    create index(:memberships, [:user_id])
    create index(:memberships, [:event_id])
  end
end

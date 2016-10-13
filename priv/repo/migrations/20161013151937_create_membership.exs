defmodule Classlab.Repo.Migrations.CreateMembership do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :role, :integer, null: false
      add :seat_position_x, :integer, null: false, default: 0
      add :seat_position_y, :integer, null: false, default: 0
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :event_id, references(:events, on_delete: :nothing), null: false
      timestamps()
    end
    create index(:memberships, [:user_id])
    create index(:memberships, [:event_id])
  end
end

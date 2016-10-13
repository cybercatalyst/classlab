defmodule Classlab.Repo.Migrations.CreateInvitation do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :email, :string, null: false
      add :first_name, :string
      add :last_name, :string
      add :invitation_token, :string, null: false
      add :completed_at, :datetime
      add :event_id, references(:events, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:invitations, [:event_id])
    create index(:invitations, [:email])
    create unique_index(:invitations, [:invitation_token])
  end
end

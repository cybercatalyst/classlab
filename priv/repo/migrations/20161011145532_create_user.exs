defmodule Classlab.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :first_name, :string
      add :last_name, :string
      add :contact_url, :string
      add :superadmin, :boolean, default: false, null: false
      add :access_token, :string, null: false
      add :access_token_expired_at, :datetime, null: false
      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:access_token])
  end
end

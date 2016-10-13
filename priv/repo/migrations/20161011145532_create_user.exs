defmodule Classlab.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :first_name, :string
      add :last_name, :string
      add :superadmin, :boolean, default: false, null: false
      add :access_token, null: false, :string
      add :access_token_expired_at, null: false, :datetime
      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:access_token])
  end
end

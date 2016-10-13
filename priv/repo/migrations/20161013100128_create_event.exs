defmodule Classlab.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :public, :boolean, default: false, null: false
      add :slug, :string, null: false
      add :name, :string, null: false
      add :description, :text, null: false
      add :invitation_token, :string, null: false
      add :invitation_token_active, :boolean, default: false, null: false
      add :starts_at, :datetime, null: false
      add :ends_at, :datetime, null: false
      add :timezone, :string, null: false
      add :location_id, references(:locations, on_delete: :nilify_all), null: false
      timestamps()
    end

    create unique_index(:events, [:slug])
    create unique_index(:events, [:invitation_token])
  end
end

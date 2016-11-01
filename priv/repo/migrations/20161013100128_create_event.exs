defmodule Classlab.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :public, :boolean, default: false, null: false
      add :slug, :string, null: false
      add :name, :string, null: false
      add :description_markdown, :text, null: false
      add :invitation_token, :string, null: false
      add :invitation_token_active, :boolean, default: false, null: false
      add :before_email_subject, :string
      add :before_email_body_text, :text
      add :after_email_subject, :string
      add :after_email_body_text, :text
      add :starts_at, :datetime, null: false
      add :ends_at, :datetime, null: false
      add :timezone, :string, null: false
      add :location_id, references(:locations, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:events, [:slug])
    create unique_index(:events, [:invitation_token])
  end
end

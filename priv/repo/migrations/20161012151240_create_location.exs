defmodule Classlab.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string, null: false
      add :address_line_1, :string, null: false
      add :address_line_2, :string
      add :zipcode, :string, null: false
      add :city, :string, null: false
      add :country, :string, null: false
      add :external_url, :string
      timestamps()
    end
  end
end

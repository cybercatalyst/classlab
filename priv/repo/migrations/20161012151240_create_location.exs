defmodule Classlab.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :address_line_1, :string
      add :address_line_2, :string
      add :zipcode, :string
      add :city, :string
      add :country, :string
      add :external_url, :string
      timestamps()
    end
  end
end

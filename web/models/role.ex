defmodule Classlab.Role do
  use Classlab.Web, :model

  # Fields
  schema "roles" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(name description)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(name)a)
  end

  # Model Functions
end

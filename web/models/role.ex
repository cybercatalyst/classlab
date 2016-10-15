defmodule Classlab.Role do
  @moduledoc """
  Role model. A role sets the permissions of a membership in a classroom.
  """
  use Classlab.Web, :model

  # Fields
  schema "roles" do
    field :name, :string
    field :description, :string
    timestamps()

    has_many :invitations, Classlab.Invitation, on_delete: :nilify_all
    has_many :memberships, Classlab.Membership, on_delete: :nilify_all
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(name description)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(name)a)
    |> unique_constraint(:name)
  end

  # Model Functions
end

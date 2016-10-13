defmodule Classlab.User do
  @moduledoc """
  User model. A user can't access events directly but only by membership.
  The membership determines the role: owner, trainer, attendee.
  """
  use Classlab.Web, :model

  # Fields
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :access_token, :string
    field :access_token_expired_at, Ecto.DateTime
    field :superadmin, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @fields [:first_name, :last_name, :email, :access_token, :access_token_expired_at]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:first_name, :last_name, :email, :access_token, :access_token_expired_at])
    |> unique_constraint(:email)
    |> unique_constraint(:access_token)
  end
end

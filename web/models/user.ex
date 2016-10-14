defmodule Classlab.User do
  @moduledoc """
  User model. A user can't access events directly but only by membership.
  The membership determines the role: owner, trainer, attendee.
  """
  alias Ecto.UUID
  use Classlab.Web, :model

  # Fields
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :access_token, :string
    field :access_token_expired_at, Calecto.DateTimeUTC
    field :superadmin, :boolean
    timestamps()

    has_many :memberships, Classlab.Membership, on_delete: :delete_all
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

  @fields [:email]
  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:email])
    |> generate_access_token()
  end

  defp generate_access_token(%Ecto.Changeset{} = changeset) do
    changeset
    |> put_change(:access_token, UUID.generate())
    |> put_change(:access_token_expired_at, Calendar.DateTime.add!(Calendar.DateTime.now_utc, 60 * 15))
  end
end

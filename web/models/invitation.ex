defmodule Classlab.Invitation do
  @moduledoc """
  Invitation model. An invitation is connected with an event.
  Invite creates membership for an event per token and email.
  """
  alias Classlab.User
  alias Ecto.UUID
  use Classlab.Web, :model

  # Fields
  schema "invitations" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :invitation_token, :string
    field :completed_at, Ecto.DateTime
    timestamps()

    belongs_to :event, Classlab.Event
    belongs_to :role, Classlab.Role
  end

  # Composable Queries
  def filter_by_email(query, %User{email: email}) do
    from inviation in query, where: inviation.email == ^email
  end

  # Changesets & Validations
  @fields ~w(email first_name last_name role_id)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> generate_invitation_token
    |> validate_required([:email, :invitation_token, :role_id])
    |> unique_constraint(:invitation_token)
    |> unique_constraint(:email, name: :invitations_email_event_id_index)
  end

  # Model Functions
  def full_name(%__MODULE__{first_name: first_name, last_name: last_name}) do
    [first_name, last_name] |> Enum.join(" ") |> String.trim()
  end

  defp generate_invitation_token(struct) do
    token = UUID.generate()
    put_change(struct, :invitation_token, token)
  end
end

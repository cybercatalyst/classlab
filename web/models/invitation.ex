defmodule Classlab.Invitation do
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

  # Changesets & Validations
  @fields ~w(email first_name last_name role_id)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> generate_invitation_token
    |> validate_required([:email, :invitation_token, :role_id])
    |> unique_constraint(:invitation_token)
  end

  # Model Functions
  defp generate_invitation_token(struct) do
    token = UUID.generate()
    put_change(struct, :invitation_token, token)
  end
end

defmodule Classlab.Event do
  @moduledoc """
  Event model. An event is connected with an user by a membership.
  Location information is a separate model.
  """
  use Classlab.Web, :model

  # Fields
  @derive {Phoenix.Param, key: :slug}
  schema "events" do
    field :public, :boolean, default: false
    field :slug, :string
    field :name, :string
    field :description, :string
    field :invitation_token, :string
    field :invitation_token_active, :boolean, default: false
    field :starts_at, Calecto.DateTimeUTC
    field :ends_at, Calecto.DateTimeUTC
    field :timezone, :string
    timestamps()

    belongs_to :location, Classlab.Location
    has_many :memberships, Classlab.Membership, on_delete: :delete_all
    # has_many :feedbacks, Classlab.Feedback
    # has_many :invitations, Classlab.Invitation
    # has_many :materials, Classlab.Material
    # has_many :tasks, Classlab.Task
  end

  # Changesets & Validations
  @fields [:public, :slug, :name, :description, :invitation_token, :invitation_token_active,
           :starts_at, :ends_at, :timezone]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> cast_assoc(:location, required: true)
    |> generate_invitation_token()
    |> validate_required([:public, :slug, :name, :description, :invitation_token,
         :invitation_token_active, :starts_at, :ends_at, :timezone])
    |> unique_constraint(:slug)
    |> unique_constraint(:invitation_token)
  end

  defp generate_invitation_token(struct, length \\ 6) do
    token = length |> :crypto.strong_rand_bytes |> Base.url_encode64 |> binary_part(0, length)
    put_change(struct, :invitation_token, token)
  end
end

defmodule Classlab.Membership do
  @moduledoc """
  A membership connects users with events.
  The role determines access rights.
  Possible roles: owner, trainer, attendee
  """
  alias Classlab.{Event}
  use Classlab.Web, :model

  # Fields
  schema "memberships" do
    field :seat_position_x, :integer, default: 0
    field :seat_position_y, :integer, default: 0
    timestamps()

    belongs_to :event, Classlab.Event
    belongs_to :role, Classlab.Role
    belongs_to :user, Classlab.User
  end

  # Composable Queries
  def for_event(query, %Event{id: event_id}) do
    from membership in query, where: membership.event_id == ^event_id
  end

  def not_as_role(query, role_id) do
    from membership in query, where: membership.role_id != ^role_id
  end

  def as_role(query, role_id) do
    from membership in query, where: membership.role_id == ^role_id
  end

  # Changesets & Validations
  @fields ~w(role_id event_id seat_position_x seat_position_y)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(role_id event_id seat_position_x seat_position_y)a)
  end

  # Model Functions
end

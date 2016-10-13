defmodule Classlab.Membership do
  @moduledoc """
  A membership connects users with events.
  The role determines access rights.
  Possible roles: owner, trainer, attendee
  """
  use Classlab.Web, :model

  # Fields
  schema "memberships" do
    field :role, :integer
    field :seat_position_x, :integer
    field :seat_position_y, :integer
    belongs_to :user, Classlab.User
    belongs_to :event, Classlab.Event
    timestamps()
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(role seat_position_x seat_position_y)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
  end

  # Model Functions
end

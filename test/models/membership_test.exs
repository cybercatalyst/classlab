defmodule Classlab.MembershipTest do
  alias Classlab.Membership
  use Classlab.ModelCase

  @valid_attrs %{role: 42, seat_position_x: 42, seat_position_y: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Membership.changeset(%Membership{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Membership.changeset(%Membership{}, @invalid_attrs)
    refute changeset.valid?
  end
end

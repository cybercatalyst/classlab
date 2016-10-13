defmodule Classlab.MembershipTest do
  alias Classlab.Membership
  use Classlab.ModelCase

  @valid_attrs Factory.params_for(:membership)
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Membership.changeset(%Membership{event_id: 1, user_id: 1}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Membership.changeset(%Membership{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

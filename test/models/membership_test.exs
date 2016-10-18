defmodule Classlab.MembershipTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Membership
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs %{"role_id" => 1}
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = Membership.changeset(%Membership{event_id: 1, user_id: 1}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Membership.changeset(%Membership{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

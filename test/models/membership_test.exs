defmodule Classlab.MembershipTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Membership
  alias Calendar.DateTime
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

  describe "#no_after_email_sent" do
    test "only returns the correct memberships" do
      correct_membership = Factory.insert(:membership, after_email_sent_at: nil)
      false_membership = Factory.insert(:membership, after_email_sent_at: DateTime.now_utc)

      memberships =
        Membership
        |> Membership.no_after_email_sent()
        |> Repo.all()

      assert length(memberships) == 1
      assert Enum.find(memberships, fn(e) -> e.id == correct_membership.id end)
      refute Enum.find(memberships, fn(e) -> e.id == false_membership.id end)
    end
  end

  describe "#touch" do
    test "puts current time in correct field in changeset" do
      changeset = Membership.changeset(%Membership{event_id: 1, user_id: 1, after_email_sent_at: nil}, @valid_attrs)
      assert Membership.touch(changeset, :after_email_sent_at)
    end

    test "replaces the correct param with the current time" do
      assert Membership.touch(%Membership{after_email_sent_at: nil}, :after_email_sent_at)
    end
  end
end

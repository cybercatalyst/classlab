defmodule Classlab.InvitationTest do
  alias Classlab.Invitation
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs %{completed_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
                   email: "person@example.com", invitation_token: "some content", role_id: 1}
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = Invitation.changeset(%Invitation{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Invitation.changeset(%Invitation{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end

  describe "#full_name" do
    test "prints the full name with a valid user" do
      full_name = Invitation.full_name(%Invitation{first_name: "John", last_name: "Doe"})
      assert full_name == "John Doe"
    end

    test "prints an empty string otherwise" do
      full_name = Invitation.full_name(%Invitation{})
      assert full_name == ""
    end
  end
end

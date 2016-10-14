defmodule Classlab.InvitationTest do
  alias Classlab.Invitation
  use Classlab.ModelCase

  @valid_attrs %{completed_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, email: "some content", first_name: "some content", invitation_token: "some content", last_name: "some content", role_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Invitation.changeset(%Invitation{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Invitation.changeset(%Invitation{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

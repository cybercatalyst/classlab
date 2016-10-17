defmodule Classlab.InvitationControllerTest do
  alias Classlab.{Invitation, Membership, User}
  use Classlab.ConnCase

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      invitation = Factory.insert(:invitation)
      conn = get conn, invitation_path(conn, :new, invitation.event, invitation.invitation_token)
      assert html_response(conn, 200) =~ invitation_path(conn, :create, invitation.event, invitation.invitation_token)
    end
  end

  describe "#create" do
    test "creates user, membership and completes invitation", %{conn: conn} do
      invitation = Factory.insert(:invitation)
      conn = post conn, invitation_path(conn, :create, invitation.event, invitation.invitation_token)
      assert redirected_to(conn) == invitation_path(conn, :show, invitation.event, invitation.invitation_token)

      user = Repo.get_by(User, email: invitation.email)
      membership = Repo.get_by(Membership, user_id: user.id)
      completed_invitation = Repo.get(Invitation, invitation.id)

      assert user
      assert membership
      assert completed_invitation.completed_at
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      invitation = Factory.insert(:invitation)
      conn = post conn, invitation_path(conn, :create, invitation.event, "asdf")
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  describe "#show" do
    test "show info about completed invitation", %{conn: conn} do
      invitation = Factory.insert(:invitation, completed_at: Calendar.DateTime.now_utc())
      conn = get conn, invitation_path(conn, :show, invitation.event, invitation.invitation_token)
      assert html_response(conn, 200) =~ "Hallo"
    end
  end
end

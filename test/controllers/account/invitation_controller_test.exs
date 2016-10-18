defmodule Classlab.Account.InvitationControllerTest do
  alias Classlab.Invitation
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      invitation = Factory.insert(:invitation, email: current_user(conn).email)
      conn = delete conn, account_invitation_path(conn, :delete, invitation)
      assert redirected_to(conn) == account_membership_path(conn, :index, active_tab: "open_invitations")
      refute Repo.get(Invitation, invitation.id)
    end

    test "does not delete chosen resource if already completed", %{conn: conn} do
      invitation = Factory.insert(:invitation, email: current_user(conn).email, completed_at: Calendar.DateTime.now_utc())
      assert_error_sent 404, fn ->
        delete conn, account_invitation_path(conn, :delete, invitation)
      end
    end
  end
end

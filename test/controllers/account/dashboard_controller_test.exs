defmodule Classlab.Account.DashboardControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#show" do
    test "shows events user owns", %{conn: conn} do
      event_as_owner =
        Factory.insert(:event,
        memberships: [Factory.insert(:membership, user: current_user(conn), role_id: 1)])

      conn = get conn, account_dashboard_path(conn, :show)
      assert html_response(conn, 200) =~ event_as_owner.name
    end

    test "shows events user attends", %{conn: conn} do
      event_as_attendee =
        Factory.insert(:event,
          memberships: [Factory.insert(:membership, user: current_user(conn), role_id: 3)])

      conn = get conn, account_dashboard_path(conn, :show)
      assert html_response(conn, 200) =~ event_as_attendee.name
    end

    test "lists only open invitations for current user", %{conn: conn} do
      open_invitation = Factory.insert(:invitation, email: current_user(conn).email)
      completed_invitation = Factory.insert(:invitation, email: current_user(conn).email, completed_at: Calendar.DateTime.now_utc())
      conn = get conn, account_dashboard_path(conn, :show)
      assert html_response(conn, 200) =~ open_invitation.event.name
      refute html_response(conn, 200) =~ completed_invitation.event.name
    end
  end
end

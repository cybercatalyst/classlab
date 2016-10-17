defmodule Classlab.Account.DashboardControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      event_as_owner =
        Factory.insert(:event,
        memberships: [Factory.insert(:membership, user: current_user(conn), role_id: 1)])
      event_as_attendee =
        Factory.insert(:event,
          memberships: [Factory.insert(:membership, user: current_user(conn), role_id: 3)])

      conn = get conn, account_dashboard_path(conn, :show)
      assert html_response(conn, 200) =~ "Dashboard"
      assert html_response(conn, 200) =~ event_as_owner.name
      assert html_response(conn, 200) =~ event_as_attendee.name
    end
  end
end

defmodule Classlab.Classroom.DashboardControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn, event: event} do
      conn = get conn, classroom_dashboard_path(conn, :show, event)
      assert html_response(conn, 200) =~ "Dashboard"
    end

    test "no event for event_id it redirects with ressource not found", %{conn: conn} do
      conn = get conn, classroom_dashboard_path(conn, :show, "123")

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) =~ "Ressource not found"
    end
  end
end

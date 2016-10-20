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
  end
end

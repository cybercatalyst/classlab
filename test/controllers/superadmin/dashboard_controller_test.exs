defmodule Classlab.Superadmin.DashboardControllerTest do
  use Classlab.ConnCase

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      conn = get conn, superadmin_dashboard_path(conn, :show)
      assert html_response(conn, 200) =~ "Dashboard"
    end
  end
end

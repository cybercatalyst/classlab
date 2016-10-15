defmodule Classlab.Classroom.DashboardControllerTest do
  use Classlab.ConnCase

  test "#show shows chosen resource", %{conn: conn} do
    conn = get conn, classroom_dashboard_path(conn, :show)
    assert html_response(conn, 200) =~ "Dashboard"
  end
end

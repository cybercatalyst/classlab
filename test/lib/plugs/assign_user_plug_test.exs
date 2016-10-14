defmodule Classlab.AssignUserPlugTest do
  alias Classlab.AssignUserPlug

  use Classlab.ConnCase

  test "#", %{conn: conn} do
    conn = AssignUserPlug.call(conn, %{})
    refute conn.assigns[:current_user]
  end
end

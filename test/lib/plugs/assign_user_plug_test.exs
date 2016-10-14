defmodule Classlab.AssignUserPlugTest do
  alias Classlab.{AssignUserPlug, Session}

  use Classlab.ConnCase

  test "VALID user_id_jwt in session it assigns the correct user", %{conn: conn} do
    user = Factory.insert(:user)
    conn =
      conn
      |> Session.login(user)
      |> AssignUserPlug.call(%{})

    assert conn.assigns[:current_user] == user
  end

  test "INVALID user_id_jwt in session it assigns nil for the user", %{conn: conn} do
    conn = AssignUserPlug.call(conn, %{})
    refute conn.assigns[:current_user]
  end
end

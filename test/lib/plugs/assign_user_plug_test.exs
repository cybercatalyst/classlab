defmodule Classlab.AssignUserPlugTest do
  alias Classlab.{AssignUserPlug, JWT.UserIdToken, Session}

  use Classlab.ConnCase

  describe "#call" do
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

    test "user_id_jwt in session calls login", %{conn: conn} do
      user = Factory.insert(:user)

      conn =
        conn
        |> put_session(:user_id_jwt, UserIdToken.encode(%UserIdToken{user_id: user.id}))
        |> AssignUserPlug.call(%{})

      assert conn.assigns[:current_user] == user
    end
  end

  describe "#init" do
    test "should return the passed options", %{conn: conn} do
      opts = %{"test" => true}
      assert AssignUserPlug.init(opts) == opts
    end
  end
end

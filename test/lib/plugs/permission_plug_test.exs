defmodule Classlab.PermissionPlugTest do
  alias Classlab.{Event, PermissionPlug, User}
  use Classlab.ConnCase

  describe "#as_user" do
    test "no redirect if user is logged in", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> assign(:current_user, %User{})
        |> PermissionPlug.as_user(%{})

      assert_raise RuntimeError, "expected connection to have redirected but no response was set/sent",  fn ->
        redirected_to(conn)
      end
    end

    test "redirects to index if current_user not set", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> PermissionPlug.as_user(%{})

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) == "Permission denied!"
    end
  end

  describe "#as_systemadmin" do
    test "no redirect if user is superadmin", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> assign(:current_user, %User{superadmin: true})
        |> PermissionPlug.as_superadmin(%{})

      assert_raise RuntimeError, "expected connection to have redirected but no response was set/sent",  fn ->
        redirected_to(conn)
      end
    end

    test "redirects to index if current_user is not superadmin", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> assign(:current_user, %User{superadmin: false})
        |> PermissionPlug.as_superadmin(%{})

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) == "Permission denied!"
    end
  end

  describe "#restrict_roles" do
    test "no redirect if there is a matching membership for user, event and roles", %{conn: conn} do
      user = Factory.insert(:user)
      event = Factory.insert(:event)
      Factory.insert(:membership, user: user, event: event, role_id: 1)

      conn =
        conn
        |> fetch_flash()
        |> assign(:current_user, user)
        |> assign(:current_event, event)
        |> PermissionPlug.restrict_roles([1])

      assert_raise RuntimeError, "expected connection to have redirected but no response was set/sent",  fn ->
        redirected_to(conn)
      end
    end

    test "redirects to index if no matching membership for event, user and roles", %{conn: conn} do
      user = Factory.insert(:user)
      event = Factory.insert(:event)

      conn =
        conn
        |> fetch_flash()
        |> assign(:current_user, user)
        |> assign(:current_event, event)
        |> PermissionPlug.restrict_roles([1])

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) == "Permission denied!"
    end

    test "redirects if current_event is not set", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> assign(:current_user, %User{})
        |> PermissionPlug.restrict_roles([1])

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) == "Permission denied!"
    end

    test "redirects if current_user is not set", %{conn: conn} do
      conn =
        conn
        |> fetch_flash()
        |> assign(:current_event, %Event{})
        |> PermissionPlug.restrict_roles([1])

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) == "Permission denied!"
    end

    test "missing roles parameter it raises an error", %{conn: conn} do
      assert_raise RuntimeError, "Missing list of roles.",  fn ->
        PermissionPlug.restrict_roles(conn, nil)
      end
    end
  end

end

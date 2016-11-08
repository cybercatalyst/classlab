defmodule Classlab.EventControllerTest do
  use Classlab.ConnCase

  describe "#index" do
    test "lists all public events on index", %{conn: conn} do
      now = Calendar.DateTime.now_utc();
      event = Factory.insert(:event, public: true, starts_at: Calendar.DateTime.add!(now, 20000), ends_at: Calendar.DateTime.add!(now, 123000))
      conn = get conn, event_path(conn, :index)
      assert html_response(conn, 200) =~ event.name
    end

    test "list shows if attending if membership exists", %{conn: conn} do
      now = Calendar.DateTime.now_utc();
      event = Factory.insert(:event, public: true, starts_at: Calendar.DateTime.add!(now, 20000), ends_at: Calendar.DateTime.add!(now, 123000))
      user = Factory.insert(:user)
      Factory.insert(:membership, user: user, event: event)
      conn = Session.login(conn, user)

      conn = get conn, event_path(conn, :index)
      assert html_response(conn, 200) =~ "attending"
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      event = Factory.insert(:event, public: true, starts_at: Calendar.DateTime.now_utc())
      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200) =~ event.name
    end

    test "shows if attending if membership exists", %{conn: conn} do
      event = Factory.insert(:event, public: true, starts_at: Calendar.DateTime.now_utc())
      user = Factory.insert(:user)
      Factory.insert(:membership, user: user, event: event)
      conn = Session.login(conn, user)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200) =~ "attending"
    end

    test "redirects to startpage if chosen resource not public", %{conn: conn} do
      event = Factory.insert(:event, starts_at: Calendar.DateTime.now_utc())
      conn = get conn, event_path(conn, :show, event)
      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) =~ "Permission denied"
    end
  end
end
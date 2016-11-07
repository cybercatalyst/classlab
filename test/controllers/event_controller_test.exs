defmodule Classlab.EventControllerTest do
  use Classlab.ConnCase

  describe "#index" do
    test "lists all public events on index", %{conn: conn} do
      now = Calendar.DateTime.now_utc();
      event = Factory.insert(:event, public: true, starts_at: Calendar.DateTime.add!(now, 20000), ends_at: Calendar.DateTime.add!(now, 123000))
      conn = get conn, event_path(conn, :index)
      assert html_response(conn, 200) =~ event.name
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      event = Factory.insert(:event, public: true, starts_at: Calendar.DateTime.now_utc())
      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200) =~ event.name
    end
  end
end
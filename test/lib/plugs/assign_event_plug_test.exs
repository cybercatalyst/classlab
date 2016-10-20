defmodule Classlab.AssignEventPlugTest do
  alias Classlab.{AssignEventPlug}
  use Classlab.ConnCase

  describe "#call" do
    test "current_event is already in assign it does nothing", %{conn: conn} do
      event = Factory.insert(:event)
      conn =
        conn
        |> assign(:current_event, event)
        |> AssignEventPlug.call(%{})

      assert conn.assigns[:current_event] == event
    end

    test "no event_id it assigns nil for the event", %{conn: conn} do
      conn =
        conn
        |> fetch_query_params()
        |> AssignEventPlug.call(%{})

      refute conn.assigns[:current_event]
    end

    test "valid event_id it assigns correct event", %{conn: conn} do
      event = Factory.insert(:event)
      conn =
        conn
        |> get("/", %{"event_id": event.slug})
        |> AssignEventPlug.call("event_id")

      assert conn.assigns[:current_event].id == event.id
    end

    test "missing id parameter it raises an error", %{conn: conn} do
      assert_raise RuntimeError, "Missing parameter for event id key.",  fn ->
        conn
        |> get("/", %{})
        |> AssignEventPlug.call(nil)
      end
    end
  end

  describe "#init" do
    test "should return the passed options" do
      opts = %{"test" => true}
      assert AssignEventPlug.init(opts) == opts
    end
  end
end

defmodule Classlab.Account.EventCopyControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn, event: event} do
      conn = get conn, account_event_event_copy_path(conn, :show, event)
      assert html_response(conn, 200) =~ event.name
    end
  end
end

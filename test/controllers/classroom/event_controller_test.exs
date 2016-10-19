defmodule Classlab.Classroom.EventControllerTest do
  alias Classlab.Event
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:event) |> Map.take(~w[public name description starts_at ends_at timezone]a)
  @invalid_attrs %{public: ""}
  @form_field "event_name"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = get conn, classroom_event_path(conn, :edit, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = put conn, classroom_event_path(conn, :update, event), event: @valid_attrs
      event = Repo.get_by(Event, @valid_attrs)
      assert redirected_to(conn) == classroom_event_path(conn, :edit, event)
      assert event
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = put conn, classroom_event_path(conn, :update, event), event: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = delete conn, classroom_event_path(conn, :delete, event)
      assert redirected_to(conn) == account_event_path(conn, :index)
      refute Repo.get(Event, event.id)
    end
  end
end

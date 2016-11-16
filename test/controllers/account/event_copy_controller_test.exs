defmodule Classlab.Account.EventCopyControllerTest do
  alias Classlab.{Event}
  alias Ecto.Query
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:event) |> Map.take(~w[name]a)

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user, role_id: 2)
    Factory.insert(:task, event: event)
    Factory.insert(:material, event: event)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#new" do
    test "new chosen resource", %{conn: conn, event: event} do
      conn = get conn, account_event_event_copy_path(conn, :new, event)
      assert html_response(conn, 200) =~ event.name
    end
  end

  describe "#create" do
    test "creates new event by copying chosen resource", %{conn: conn, event: event} do
      conn = post conn, account_event_event_copy_path(conn, :create, event), event: @valid_attrs

      new_event =
        Event
        |> Query.order_by(desc: :id)
        |> Query.limit(1)
        |> Repo.one!()
        |> Repo.preload([:tasks, :location, :materials])

      assert redirected_to(conn) == classroom_dashboard_path(conn, :show, new_event)
      assert length(Repo.all(Event)) == 2
      assert length(new_event.tasks) == 1
      assert length(new_event.materials) == 1
      refute new_event.location
    end

    test "creates new event by copying chosen resource with location", %{conn: conn} do
      event = Factory.insert(:event, location: Factory.build(:location))
      Factory.insert(:membership, event: event, user: current_user(conn), role_id: 2)
      conn = post conn, account_event_event_copy_path(conn, :create, event), event: @valid_attrs

      new_event =
        Event
        |> Query.order_by(desc: :id)
        |> Query.limit(1)
        |> Repo.one!()
        |> Repo.preload([:tasks, :location, :materials])

      assert redirected_to(conn) == classroom_dashboard_path(conn, :show, new_event)
      assert length(Repo.all(Event)) == 3
      assert new_event.location
    end
  end
end

defmodule Classlab.Account.EventControllerTest do
  alias Classlab.Event
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:event) |> Map.take(~w[public slug name description starts_at ends_at timezone]a)

  @invalid_attrs %{public: ""}
  @form_field "event_name"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index for current user as owner", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = get conn, account_event_path(conn, :index)
      assert html_response(conn, 200) =~ event.name
    end

    test "lists all entries on index for current user as owner2", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 3)
      conn = get conn, account_event_path(conn, :index)
      refute html_response(conn, 200) =~ event.name
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      conn = get conn, account_event_path(conn, :new)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, account_event_path(conn, :create), event: Map.put(@valid_attrs, :location, Factory.params_for(:location))
      assert redirected_to(conn) == account_event_path(conn, :index)
      assert Repo.get_by(Event, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, account_event_path(conn, :create), event: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = get conn, account_event_path(conn, :show, event)
      assert html_response(conn, 200) =~ event.name
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, account_event_path(conn, :show, -1)
      end
    end
  end


  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = get conn, account_event_path(conn, :edit, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = put conn, account_event_path(conn, :update, event), event: @valid_attrs
      assert redirected_to(conn) == account_event_path(conn, :show, @valid_attrs.slug)
      assert Repo.get_by(Event, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = put conn, account_event_path(conn, :update, event), event: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      event = Factory.insert(:event)
      Factory.insert(:membership, user: current_user(conn), event: event, role_id: 1)
      conn = delete conn, account_event_path(conn, :delete, event)
      assert redirected_to(conn) == account_event_path(conn, :index)
      refute Repo.get(Event, event.id)
    end
  end
end

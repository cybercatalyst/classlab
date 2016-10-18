defmodule Classlab.Classroom.MembershipControllerTest do
  alias Classlab.Membership
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index where current user is not owner", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn), role_id: 3)
      conn = get conn, classroom_membership_path(conn, :index, membership.event)
      assert html_response(conn, 200) =~ membership.user.email
    end

    test "shows nothing if user is owner of an event", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn))
      conn = get conn, classroom_membership_path(conn, :index, membership.event)
      refute html_response(conn, 200) =~ membership.user.email
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn))
      conn = delete conn, classroom_membership_path(conn, :delete, membership.event, membership)
      assert redirected_to(conn) == classroom_membership_path(conn, :index, membership.event)
      refute Repo.get(Membership, membership.id)
    end
  end
end

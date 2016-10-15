defmodule Classlab.Classroom.MembershipControllerTest do
  alias Classlab.Membership
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  test "#index lists all entries on index", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = get conn, classroom_membership_path(conn, :index, membership.event)
    assert html_response(conn, 200) =~ "Role"
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    membership = Factory.insert(:membership, user: current_user(conn))
    conn = delete conn, classroom_membership_path(conn, :delete, membership.event, membership)
    assert redirected_to(conn) == classroom_membership_path(conn, :index, membership.event)
    refute Repo.get(Membership, membership.id)
  end
end

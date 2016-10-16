defmodule Classlab.Account.MembershipControllerTest do
  alias Classlab.Membership
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn} do
      Factory.insert(:membership)
      conn = get conn, account_membership_path(conn, :index)
      assert html_response(conn, 200) =~ "Role"
    end
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    membership = Factory.insert(:membership, user: current_user(conn))
    conn = delete conn, account_membership_path(conn, :delete, membership)
    assert redirected_to(conn) == account_membership_path(conn, :index)
    refute Repo.get(Membership, membership.id)
  end
end

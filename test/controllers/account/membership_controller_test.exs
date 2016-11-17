defmodule Classlab.Account.MembershipControllerTest do
  alias Classlab.{Invitation, Membership}
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index where current user is not owner", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn), role_id: 3)
      conn = get conn, account_membership_path(conn, :index)
      assert html_response(conn, 200) =~ membership.event.name
    end

    test "lists all entries on index where current user is owner", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn))
      conn = get conn, account_membership_path(conn, :index)
      assert html_response(conn, 200) =~ membership.event.name
    end
  end

  describe "#delete" do
    test "deletes chosen resource if current user is not owner", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn), role_id: 3)
      conn = delete conn, account_membership_path(conn, :delete, membership)
      assert redirected_to(conn) == account_membership_path(conn, :index)
      refute Repo.get(Membership, membership.id)
    end

    test "deletes invitation if existing", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn), role_id: 3)
      invitation = Factory.insert(:invitation, email: current_user(conn).email, role_id: 3, event: membership.event)
      conn = delete conn, account_membership_path(conn, :delete, membership)
      assert redirected_to(conn) == account_membership_path(conn, :index)
      refute Repo.get(Invitation, invitation.id)
    end

    test "fails if current user is owner of the chosen resource", %{conn: conn} do
      membership = Factory.insert(:membership, user: current_user(conn))
      assert_error_sent 301, fn ->
        delete conn, account_membership_path(conn, :delete, membership)
      end
    end
  end
end

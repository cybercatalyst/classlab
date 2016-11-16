defmodule Classlab.AssignMembershipsPlugTest do
  alias Classlab.{AssignMembershipsPlug, Membership, User}
  use Classlab.ConnCase

  describe "#call" do
    test "current_memberships is already in assign it does nothing", %{conn: conn} do
      membership = Factory.insert(:membership)
      conn =
        conn
        |> assign(:current_memberships, [membership])
        |> AssignMembershipsPlug.call(%{})

      assert conn.assigns[:current_memberships] == [membership]
    end

    test "no current_user it assigns nil for the memberships", %{conn: conn} do
      conn =
        conn
        |> AssignMembershipsPlug.call(%{})

      refute conn.assigns[:current_memberships]
    end

    test "no current_event it assigns nil for the memberships", %{conn: conn} do
      conn =
        conn
        |> assign(:current_user, %User{id: 1, email: 'test@example.com'})
        |> AssignMembershipsPlug.call(%{})

      refute conn.assigns[:current_memberships]
    end

    test "valid user and event it assigns correct memberships", %{conn: conn} do
      membership = Factory.insert(:membership)
      conn =
        conn
        |> assign(:current_user, membership.user)
        |> assign(:current_event, membership.event)
        |> AssignMembershipsPlug.call(%{})

      memberships =
        membership.user
        |> assoc(:memberships)
        |> Membership.for_event(membership.event)
        |> Repo.all()
        |> Repo.preload(:role)

      assert length(conn.assigns[:current_memberships]) == 1
      assert conn.assigns[:current_memberships] == memberships
    end
  end

  describe "#init" do
    test "should return the passed options" do
      opts = %{"test" => true}
      assert AssignMembershipsPlug.init(opts) == opts
    end
  end
end

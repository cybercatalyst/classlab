defmodule Classlab.MembershipControllerTest do
  alias Classlab.Membership
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:membership) |> Map.take(~w[user_id event_id role seat_position_x seat_position_y]a)
  @invalid_attrs %{user_id: ""}
  @form_field "membership_user_id"

  test "#index lists all entries on index", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = get conn, membership_path(conn, :index)
    assert html_response(conn, 200) =~ membership.user_id
  end

  test "#new renders form for new resources", %{conn: conn} do
    conn = get conn, membership_path(conn, :new)
    assert html_response(conn, 200) =~ @form_field
  end

  # test "#create creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, membership_path(conn, :create), membership: @valid_attrs
  #   assert redirected_to(conn) == membership_path(conn, :index)
  #   assert Repo.get_by(Membership, @valid_attrs)
  # end

  # test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, membership_path(conn, :create), membership: @invalid_attrs
  #   assert html_response(conn, 200) =~ @form_field
  # end

  test "#show shows chosen resource", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = get conn, membership_path(conn, :show, membership)
    assert html_response(conn, 200) =~ membership.user_id
  end

  test "#show renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, membership_path(conn, :show, -1)
    end
  end

  test "#edit renders form for editing chosen resource", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = get conn, membership_path(conn, :edit, membership)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#update updates chosen resource and redirects when data is valid", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = put conn, membership_path(conn, :update, membership), membership: @valid_attrs
    assert redirected_to(conn) == membership_path(conn, :show, membership)
    assert Repo.get_by(Membership, @valid_attrs)
  end

  test "#update does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = put conn, membership_path(conn, :update, membership), membership: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    membership = Factory.insert(:membership)
    conn = delete conn, membership_path(conn, :delete, membership)
    assert redirected_to(conn) == membership_path(conn, :index)
    refute Repo.get(Membership, membership.id)
  end
end

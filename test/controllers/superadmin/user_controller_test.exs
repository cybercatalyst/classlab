defmodule Classlab.Superadmin.UserControllerTest do
  alias Classlab.User
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:user) |> Map.take(~w[email first_name last_name]a)
  @invalid_attrs %{email: ""}
  @form_field "user_email"

  setup %{conn: conn} do
    user = Factory.insert(:user, superadmin: true)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn} do
      user = Factory.insert(:user)
      conn = get conn, superadmin_user_path(conn, :index)
      assert html_response(conn, 200) =~ user.email
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      user = Factory.insert(:user)
      conn = get conn, superadmin_user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  test "#update updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Factory.insert(:user)
    conn = put conn, superadmin_user_path(conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == superadmin_user_path(conn, :edit, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "#update does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Factory.insert(:user)
    conn = put conn, superadmin_user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    user = Factory.insert(:user)
    conn = delete conn, superadmin_user_path(conn, :delete, user)
    assert redirected_to(conn) == superadmin_user_path(conn, :index)
    refute Repo.get(User, user.id)
  end
end

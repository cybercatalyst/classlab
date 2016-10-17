defmodule Classlab.Account.UserControllerTest do
  alias Classlab.User
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:user) |> Map.take(~w[email first_name last_name]a)
  @invalid_attrs %{email: ""}
  @form_field "user_email"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      conn = get conn, account_user_path(conn, :edit)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      conn = put conn, account_user_path(conn, :update), user: @valid_attrs
      assert redirected_to(conn) == account_user_path(conn, :edit)
      assert Repo.get_by(User, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      conn = put conn, account_user_path(conn, :update), user: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end
end

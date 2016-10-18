defmodule Classlab.SessionControllerTest do
  alias Classlab.{User, UserMailer}
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:session)
  @invalid_attrs %{email: ""}
  @form_field "email"

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#show" do
    test "VALID TOKEN redirects to index page with session", %{conn: conn} do
      access_token_expired_at = Calendar.DateTime.add!(Calendar.DateTime.now_utc, 60 * 15)
      user = Factory.insert(:user, access_token_expired_at: access_token_expired_at)
      conn = get conn, session_path(conn, :show, user.access_token)
      assert redirected_to(conn) == account_dashboard_path(conn, :show)
    end

    test "EXPIRED TOKEN redirects to new session page", %{conn: conn} do
      access_token_expired_at = Calendar.DateTime.subtract!(Calendar.DateTime.now_utc, 60)
      user = Factory.insert(:user, access_token_expired_at: access_token_expired_at)
      conn = get conn, session_path(conn, :show, user.access_token)
      assert redirected_to(conn) == session_path(conn, :new)
    end

    test "INVALID TOKEN redirects to new session page", %{conn: conn} do
      conn = get conn, session_path(conn, :show, "invalid")
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end

  describe "#create" do
    test "Creates resource and redirects when data is valid for new user", %{conn: conn} do
      user = Factory.insert(:user)
      conn = post conn, session_path(conn, :create), session: %{email: user.email}
      assert redirected_to(conn) == page_path(conn, :index)

      user = Repo.one(User)
      assert user
      assert_delivered_email UserMailer.token_email(user)
    end

    test "Creates resource and redirects when data is valid for exiting user", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @valid_attrs
      assert redirected_to(conn) == page_path(conn, :index)

      user = Repo.one(User)
      assert user
      assert_delivered_email UserMailer.token_email(user)
    end

    test "Does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, session_path(conn, :create), session: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "logout", %{conn: conn} do
      user = Factory.insert(:user)

      conn =
        conn
        |> Session.login(user)
        |> delete(session_path(conn, :delete))

      assert redirected_to(conn) == page_path(conn, :index)
      assert get_flash(conn, :error) =~ "Logged out"
      refute current_user(conn)
    end
  end
end

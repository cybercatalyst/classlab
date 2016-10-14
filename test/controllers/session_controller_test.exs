defmodule Classlab.SessionControllerTest do
  alias Classlab.User
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:session)
  @invalid_attrs %{email: ""}
  @form_field "email"

  test "#new renders form for new resources", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#create creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)

    user = Repo.one(User)
    assert user
    assert_delivered_email Classlab.UserMailer.token_email(user)
  end

  test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end
end

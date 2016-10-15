defmodule Classlab.Account.InvitationControllerTest do
  alias Classlab.Invitation
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:invitation) |> Map.take(~w[email role_id]a)
  @invalid_attrs %{email: ""}
  @form_field "invitation_email"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  test "#index lists all entries on index", %{conn: conn} do
    invitation = Factory.insert(:invitation, email: current_user(conn).email)
    conn = get conn, account_invitation_path(conn, :index)
    assert html_response(conn, 200) =~ invitation.email
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    invitation = Factory.insert(:invitation, email: current_user(conn).email)
    conn = delete conn, account_invitation_path(conn, :delete, invitation)
    assert redirected_to(conn) == account_invitation_path(conn, :index)
    refute Repo.get(Invitation, invitation.id)
  end
end

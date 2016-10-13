defmodule Classlab.InvitationControllerTest do
  alias Classlab.Invitation
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:invitation) |> Map.take(~w[email]a)
  @invalid_attrs %{email: ""}
  @form_field "invitation_email"

  test "#index lists all entries on index", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = get conn, event_invitation_path(conn, :index, invitation.event)
    assert html_response(conn, 200) =~ invitation.email
  end

  test "#new renders form for new resources", %{conn: conn} do
    event = Factory.insert(:event)
    conn = get conn, event_invitation_path(conn, :new, event)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#create creates resource and redirects when data is valid", %{conn: conn} do
    event = Factory.insert(:event)
    conn = post conn, event_invitation_path(conn, :create, event), invitation: @valid_attrs
    assert redirected_to(conn) == event_invitation_path(conn, :index, event)
    assert Repo.get_by(Invitation, @valid_attrs)
  end

  test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
    event = Factory.insert(:event)
    conn = post conn, event_invitation_path(conn, :create, event), invitation: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#show shows chosen resource", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = get conn, event_invitation_path(conn, :show, invitation.event, invitation)
    assert html_response(conn, 200) =~ invitation.email
  end

  test "#show renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, event_invitation_path(conn, :show, -1, -1)
    end
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = delete conn, event_invitation_path(conn, :delete, invitation.event, invitation)
    assert redirected_to(conn) == event_invitation_path(conn, :index, invitation.event)
    refute Repo.get(Invitation, invitation.id)
  end
end

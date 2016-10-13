defmodule Classlab.InvitationControllerTest do
  alias Classlab.Invitation
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:invitation) |> Map.take(~w[event_id email first_name last_name invitation_token completed_at]a)
  @invalid_attrs %{event_id: ""}
  @form_field "invitation_event_id"

  test "#index lists all entries on index", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = get conn, invitation_path(conn, :index)
    assert html_response(conn, 200) =~ invitation.event_id
  end

  test "#new renders form for new resources", %{conn: conn} do
    conn = get conn, invitation_path(conn, :new)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#create creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, invitation_path(conn, :create), invitation: @valid_attrs
    assert redirected_to(conn) == invitation_path(conn, :index)
    assert Repo.get_by(Invitation, @valid_attrs)
  end

  test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, invitation_path(conn, :create), invitation: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#show shows chosen resource", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = get conn, invitation_path(conn, :show, invitation)
    assert html_response(conn, 200) =~ invitation.event_id
  end

  test "#show renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, invitation_path(conn, :show, -1)
    end
  end

  test "#edit renders form for editing chosen resource", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = get conn, invitation_path(conn, :edit, invitation)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    invitation = Factory.insert(:invitation)
    conn = delete conn, invitation_path(conn, :delete, invitation)
    assert redirected_to(conn) == invitation_path(conn, :index)
    refute Repo.get(Invitation, invitation.id)
  end
end

defmodule Classlab.Classroom.InvitationControllerTest do
  alias Classlab.{Invitation, InvitationMailer}
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:invitation) |> Map.take(~w[email role_id]a)
  @invalid_attrs %{email: ""}
  @form_field "invitation_email"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user, role_id: 1)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn, event: event} do
      conn = get conn, classroom_invitation_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn, event: event} do
      conn = post conn, classroom_invitation_path(conn, :create, event), invitation: @valid_attrs
      assert redirected_to(conn) == classroom_membership_path(conn, :index, event)
      invitation =
        Invitation
        |> Repo.get_by(@valid_attrs)
        |> Repo.preload(:event)
      assert invitation
      assert_delivered_email InvitationMailer.invitation_email(invitation)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, event: event} do
      conn = post conn, classroom_invitation_path(conn, :create, event), invitation: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn, event: event} do
      invitation = Factory.insert(:invitation, event: event)
      conn = delete conn, classroom_invitation_path(conn, :delete, invitation.event, invitation)
      assert redirected_to(conn) == classroom_membership_path(conn, :index, invitation.event)
      refute Repo.get(Invitation, invitation.id)
    end
  end
end

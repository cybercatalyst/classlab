defmodule Classlab.InvitationControllerTest do
  alias Classlab.{Invitation, InvitationMailer}
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:invitation) |> Map.take(~w[email role_id]a)
  @invalid_attrs %{email: ""}
  @form_field "invitation_email"

  setup %{conn: conn} do
    event = Factory.insert(:event, public: true)
    {:ok, conn: conn, event: event}
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn, event: event} do
      conn = get conn, event_invitation_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end

    test "redirects if not a public event", %{conn: conn} do
      event = Factory.insert(:event, public: false)
      conn = get conn, event_invitation_path(conn, :new, event)
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn, event: event} do
      conn = post conn, event_invitation_path(conn, :create, event), invitation: @valid_attrs
      assert redirected_to(conn) == event_path(conn, :show, event)
      invitation =
        Invitation
        |> Repo.get_by(@valid_attrs)
        |> Repo.preload(:event)
      assert invitation
      assert_delivered_email InvitationMailer.invitation_email(invitation)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, event: event} do
      conn = post conn, event_invitation_path(conn, :create, event), invitation: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end

    test "redirects if not a public event", %{conn: conn} do
      event = Factory.insert(:event, public: false)
      conn = post conn, event_invitation_path(conn, :create, event), invitation: @valid_attrs
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end
end

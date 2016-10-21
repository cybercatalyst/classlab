defmodule Classlab.Classroom.EventEmailTemplateControllerTest do
  alias Classlab.Event
  use Classlab.ConnCase

  @valid_attrs %{
    before_email_subject: "Before Subject",
    before_email_body_text: "Before Text",
    after_email_subject: "After Subject",
    after_email_body_text: "After Text"
  }
  @invalid_attrs %{}
  @form_field "event_before_email_subject"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user, role_id: 1)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn, event: event} do
      conn = get conn, classroom_event_email_template_path(conn, :edit, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn, event: event} do
      conn = put conn, classroom_event_email_template_path(conn, :update, event), event: @valid_attrs
      event = Repo.get_by(Event, @valid_attrs)
      assert redirected_to(conn) == classroom_event_email_template_path(conn, :edit, event)
      assert event.before_email_subject == @valid_attrs.before_email_subject
    end
  end
end

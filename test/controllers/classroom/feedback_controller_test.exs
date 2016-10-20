defmodule Classlab.Classroom.FeedbackControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user, role_id: 1)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn, event: event} do
      feedback = Factory.insert(:feedback, event: event)
      conn = get conn, classroom_feedback_path(conn, :index, feedback.event)
      assert html_response(conn, 200) =~ feedback.content_comment
    end
  end
end

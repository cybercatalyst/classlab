defmodule Classlab.Classroom.FeedbackControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  test "#index lists all entries on index", %{conn: conn} do
    feedback = Factory.insert(:feedback)
    conn = get conn, classroom_feedback_path(conn, :index, feedback.event)
    assert html_response(conn, 200) =~ feedback.content_comment
  end
end

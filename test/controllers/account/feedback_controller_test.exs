defmodule Classlab.Account.FeedbackControllerTest do
  use Classlab.ConnCase

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = get conn, account_feedback_path(conn, :index)
      assert html_response(conn, 200) =~ feedback.testimonial
    end
  end
end

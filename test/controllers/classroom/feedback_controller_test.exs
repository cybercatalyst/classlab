defmodule Classlab.Classroom.FeedbackControllerTest do
  alias Calendar.DateTime
  alias Classlab.{Feedback, Membership}
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:feedback) |> Map.take(~w[content_rating content_comment trainer_rating location_rating]a)
  @invalid_attrs %{trainer_rating: -1}
  @form_field "feedback_content_comment"

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

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      event = Factory.insert(:event, ends_at: DateTime.now_utc(), memberships: [%Membership{user: current_user(conn), role_id: 3}]);
      conn = get conn, classroom_feedback_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end

    test "does not create resource when not allowed to add feedback", %{conn: conn} do
      event = Factory.insert(:event, memberships: [%Membership{user: current_user(conn), role_id: 3}]);
      assert_error_sent 301, fn ->
        post conn, classroom_feedback_path(conn, :create, event), feedback: @invalid_attrs
      end
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      event = Factory.insert(:event, ends_at: DateTime.now_utc(), memberships: [%Membership{user: current_user(conn), role_id: 3}])
      conn = post conn, classroom_feedback_path(conn, :create, event), feedback: @valid_attrs |> Map.put(:event_id, event.id)
      assert redirected_to(conn) == classroom_feedback_path(conn, :show, event)
      assert Repo.get_by(Feedback, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      event = Factory.insert(:event, ends_at: DateTime.now_utc(), memberships: [%Membership{user: current_user(conn), role_id: 3}])
      conn = post conn, classroom_feedback_path(conn, :create, event), feedback: @invalid_attrs |> Map.put(:event_id, event.id)
      assert html_response(conn, 200) =~ @form_field
    end

    test "does not create resource when there is already a feedback", %{conn: conn} do
      event = Factory.insert(:event, ends_at: DateTime.now_utc(), memberships: [%Membership{user: current_user(conn), role_id: 3}])
      Factory.insert(:feedback, user: current_user(conn), event: event)
      assert_error_sent 301, fn ->
        post conn, classroom_feedback_path(conn, :create, event), feedback: @invalid_attrs
      end
    end

    test "does not create resource when not allowed to add feedback", %{conn: conn} do
      event = Factory.insert(:event, memberships: [%Membership{user: current_user(conn), role_id: 3}]);
      assert_error_sent 301, fn ->
        post conn, classroom_feedback_path(conn, :create, event), feedback: @invalid_attrs
      end
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      event = Factory.insert(:event, memberships: [%Membership{user: current_user(conn), role_id: 3}]);
      feedback = Factory.insert(:feedback, event: event, user: current_user(conn))
      conn = get conn, classroom_feedback_path(conn, :show, feedback.event)
      assert html_response(conn, 200) =~ feedback.content_comment
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      event = Factory.insert(:event, memberships: [%Membership{user: current_user(conn), role_id: 3}]);
      feedback = Factory.insert(:feedback, event: event, user: current_user(conn))
      conn = get conn, classroom_feedback_path(conn, :edit, feedback.event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn, event: event} do
      Factory.insert(:membership, event: event, user: current_user(conn), role_id: 3)
      feedback = Factory.insert(:feedback, user: current_user(conn), event: event)
      conn = put conn, classroom_feedback_path(conn, :update, feedback.event), feedback: @valid_attrs
      assert redirected_to(conn) == classroom_feedback_path(conn, :show, feedback.event)
      assert Repo.get_by(Feedback, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, event: event} do
      Factory.insert(:membership, event: event, user: current_user(conn), role_id: 3)
      feedback = Factory.insert(:feedback, user: current_user(conn), event: event)
      conn = put conn, classroom_feedback_path(conn, :update, feedback.event), feedback: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn, event: event} do
      Factory.insert(:membership, event: event, user: current_user(conn), role_id: 3)
      feedback = Factory.insert(:feedback, user: current_user(conn), event: event)
      conn = delete conn, classroom_feedback_path(conn, :delete, feedback.event)
      assert redirected_to(conn) == classroom_feedback_path(conn, :show, feedback.event)
      refute Repo.get(Feedback, feedback.id)
    end
  end
end

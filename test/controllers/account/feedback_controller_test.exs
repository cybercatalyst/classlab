defmodule Classlab.Account.FeedbackControllerTest do
  alias Classlab.{Feedback, Membership}
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:feedback) |> Map.take(~w[content_rating content_comment trainer_rating location_rating]a)
  @invalid_attrs %{trainer_rating: ""}
  @form_field "feedback_content_comment"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = get conn, account_feedback_path(conn, :index)
      assert html_response(conn, 200) =~ feedback.content_comment
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      conn = get conn, account_feedback_path(conn, :new)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      event = Factory.insert(:event, memberships: [%Membership{user: current_user(conn), role_id: 3}])
      conn = post conn, account_feedback_path(conn, :create), feedback: @valid_attrs |> Map.put(:event_id, event.id)
      assert redirected_to(conn) == account_feedback_path(conn, :index)
      assert Repo.get_by(Feedback, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, account_feedback_path(conn, :create), feedback: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = get conn, account_feedback_path(conn, :show, feedback)
      assert html_response(conn, 200) =~ feedback.content_comment
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, account_feedback_path(conn, :show, -1)
      end
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = get conn, account_feedback_path(conn, :edit, feedback)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = put conn, account_feedback_path(conn, :update, feedback), feedback: @valid_attrs
      assert redirected_to(conn) == account_feedback_path(conn, :show, feedback)
      assert Repo.get_by(Feedback, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = put conn, account_feedback_path(conn, :update, feedback), feedback: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      feedback = Factory.insert(:feedback, user: current_user(conn))
      conn = delete conn, account_feedback_path(conn, :delete, feedback)
      assert redirected_to(conn) == account_feedback_path(conn, :index)
      refute Repo.get(Feedback, feedback.id)
    end
  end
end

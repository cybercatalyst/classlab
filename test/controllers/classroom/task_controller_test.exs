defmodule Classlab.Classroom.TaskControllerTest do
  alias Classlab.Task
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:task) |> Map.take(~w[body position title]a)
  @invalid_attrs %{title: ""}
  @form_field "task_title"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user, role_id: 1)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event)
      conn = get conn, classroom_task_path(conn, :index, task.event)
      assert html_response(conn, 200) =~ task.title
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn, event: event} do
      conn = get conn, classroom_task_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn, event: event} do
      conn = post conn, classroom_task_path(conn, :create, event), task: @valid_attrs
      task = Repo.get_by(Task, @valid_attrs)

      assert task
      assert redirected_to(conn) == classroom_task_path(conn, :show, event, task)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, event: event} do
      conn = post conn, classroom_task_path(conn, :create, event), task: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event)
      conn = get conn, classroom_task_path(conn, :show, task.event, task)
      assert html_response(conn, 200) =~ task.title
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, classroom_task_path(conn, :show, -1, -1)
      end
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event)
      conn = get conn, classroom_task_path(conn, :edit, task.event, task)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event)
      conn = put conn, classroom_task_path(conn, :update, task.event, task), task: @valid_attrs
      assert redirected_to(conn) == classroom_task_path(conn, :show, task.event, task)
      assert Repo.get_by(Task, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event)
      conn = put conn, classroom_task_path(conn, :update, task.event, task), task: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#unlock all" do
    test "shows chosen resource", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event, public: false)
      conn = post conn, classroom_task_path(conn, :unlock_all, event)

      task = Repo.get(Task, task.id)

      assert redirected_to(conn) == classroom_task_path(conn, :index, event)
      assert task.public == true
      assert task.unlocked_at
    end
  end

  describe "#lock all" do
    test "shows chosen resource", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event, public: true)
      conn = post conn, classroom_task_path(conn, :lock_all, event)

      task = Repo.get(Task, task.id)

      assert redirected_to(conn) == classroom_task_path(conn, :index, event)
      assert task.public == false
      refute task.unlocked_at
    end
  end

  describe "#unlock_next" do
    test "unlocks next resource and shows resource", %{conn: conn, event: event} do
      first_task = Factory.insert(:task, event: event, public: true, position: 1)
      second_task = Factory.insert(:task, event: event, public: false, position: 2)
      third_task = Factory.insert(:task, event: event, public: false, position: 3)
      conn = post conn, classroom_task_path(conn, :unlock_next, event)

      first_task = Repo.get(Task, first_task.id)
      second_task = Repo.get(Task, second_task.id)
      third_task = Repo.get(Task, third_task.id)

      assert redirected_to(conn) == classroom_task_path(conn, :show, event, second_task)
      assert first_task.public == true
      assert second_task.public == true
      assert second_task.unlocked_at
      assert third_task.public == false
    end

    test "nothing to unlock redirects to #index", %{conn: conn, event: event} do
      Factory.insert(:task, event: event, public: true)
      conn = post conn, classroom_task_path(conn, :unlock_next, event)

      assert redirected_to(conn) == classroom_task_path(conn, :index, event)
    end
  end

  describe "#toggle_lock" do
    test "unlocks resource if not public", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event, public: false)
      conn = post conn, classroom_task_path(conn, :toggle_lock, event, task)

      task = Repo.get(Task, task.id)

      assert redirected_to(conn) == classroom_task_path(conn, :index, event)
      assert task.public == true
      assert task.unlocked_at
    end

    test "lock resource if public", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event, public: true)
      conn = post conn, classroom_task_path(conn, :toggle_lock, event, task)

      task = Repo.get(Task, task.id)

      assert redirected_to(conn) == classroom_task_path(conn, :index, event)
      assert task.public == false
      refute task.unlocked_at
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn, event: event} do
      task = Factory.insert(:task, event: event)
      conn = delete conn, classroom_task_path(conn, :delete, task.event, task)
      assert redirected_to(conn) == classroom_task_path(conn, :index, task.event)
      refute Repo.get(Task, task.id)
    end
  end
end

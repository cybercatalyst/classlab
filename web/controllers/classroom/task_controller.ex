defmodule Classlab.Classroom.TaskController do
  @moduledoc false

  alias Calendar.DateTime
  alias Ecto.{Changeset, Query}
  alias Classlab.{Membership, Repo, Task}
  use Classlab.Web, :controller

  plug :scrub_params, "task" when action in [:create, :update]
  plug :restrict_roles, [1, 2] when action in
      [:create, :delete, :edit, :lock_all, :new, :toggle_lock, :update, :unlock_all, :unlock_next]

  def index(conn, _params) do
    event = current_event(conn)
    public_tasks =
      event
      |> assoc(:tasks)
      |> Task.public()
      |> Query.order_by([asc: :unlocked_at, asc: :position])
      |> Repo.all()

    not_public_tasks =
      event
      |> assoc(:tasks)
      |> Task.not_public()
      |> Query.order_by(asc: :position)
      |> Repo.all()

    current_memberships =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.for_event(event)
      |> Repo.all()

    render(conn, "index.html", current_memberships: current_memberships, event: event, not_public_tasks: not_public_tasks, public_tasks: public_tasks)
  end

  def new(conn, _params) do
    event = current_event(conn)
    changeset = Task.changeset(%Task{})

    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"task" => task_params}) do
    event = current_event(conn)
    changeset =
      event
      |> build_assoc(:tasks)
      |> Task.changeset(task_params)

    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: classroom_task_path(conn, :show, event, task))
      {:error, changeset} ->
        render(conn, "new.html", event: event, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => task_id}) do
    event = current_event(conn)
    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)

    changeset = Task.changeset(task)

    render(conn, "edit.html", event: event, changeset: changeset, task: task)
  end

  def show(conn, %{"id" => task_id}) do
    event = current_event(conn)
    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)

    current_memberships =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.for_event(event)
      |> Repo.all()

    render(conn, "show.html", current_memberships: current_memberships, event: event, task: task)
  end

  def update(conn, %{"id" => task_id, "task" => task_params}) do
    event = current_event(conn)
    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: classroom_task_path(conn, :show, event, task))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset, task: task)
    end
  end

  def unlock_all(conn, _params) do
    event = current_event(conn)

    event
    |> assoc(:tasks)
    |> Task.not_public()
    |> Repo.update_all([set: [public: true, unlocked_at: DateTime.now_utc()]])

    conn
    |> put_flash(:info, "Tasks successfully unlocked.")
    |> redirect(to: classroom_task_path(conn, :index, event))
  end

  def lock_all(conn, _params) do
    event = current_event(conn)

    event
    |> assoc(:tasks)
    |> Task.public()
    |> Repo.update_all([set: [public: false, unlocked_at: nil]])

    conn
    |> put_flash(:info, "Tasks successfully locked.")
    |> redirect(to: classroom_task_path(conn, :index, event))
  end

  def unlock_next(conn, _params) do
    event = current_event(conn)

    task_res = event
    |> assoc(:tasks)
    |> Task.not_public()
    |> Query.order_by(asc: :position)
    |> Query.first
    |> Repo.one()

    case task_res do
      %Task{} = task ->
        task
        |> Changeset.change(%{public: true, unlocked_at: DateTime.now_utc()})
        |> Repo.update!()

        conn
        |> put_flash(:info, "Task successfully unlocked.")
        |> redirect(to: classroom_task_path(conn, :show, event, task))
      nil ->
        conn
        |> put_flash(:error, "No task left.")
        |> redirect(to: classroom_task_path(conn, :index, event))
    end
  end

  def toggle_lock(conn, %{"id" => task_id}) do
    event = current_event(conn)

    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)

    updates =
      if task.public do
        %{public: false, unlocked_at: nil}
      else
        %{public: true, unlocked_at: DateTime.now_utc()}
      end

    task
    |> Changeset.change(updates)
    |> Repo.update!()

    flash =
      if task.public do
        "Task successfully locked"
      else
        "Task successfully unlocked"
      end

    conn
    |> put_flash(:info, flash)
    |> redirect(to: classroom_task_path(conn, :index, event))
  end

  def delete(conn, %{"id" => task_id}) do
    event = current_event(conn)
    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)

    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: classroom_task_path(conn, :index, event))
  end

  # Private methods
end

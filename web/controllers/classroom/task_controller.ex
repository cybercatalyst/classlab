defmodule Classlab.Classroom.TaskController do
  @moduledoc false

  alias Calendar.DateTime
  alias Ecto.{Changeset, Query}
  alias Classlab.{Event, Membership, Repo, Task}
  use Classlab.Web, :controller

  plug :scrub_params, "task" when action in [:create, :update]
  plug :restrict_roles, [1, 2] when action in
      [:create, :delete, :edit, :lock_all, :new, :toggle_lock, :update, :unlock_all, :unlock_next]

  def index(conn, _params) do
    event = current_event(conn)
    unlocked_tasks =
      event
      |> assoc(:tasks)
      |> Task.unlocked()
      |> Query.order_by([asc: :unlocked_at, asc: :position])
      |> Repo.all()

    locked_tasks =
      event
      |> assoc(:tasks)
      |> Task.locked()
      |> Query.order_by(asc: :position)
      |> Repo.all()

    current_memberships =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.for_event(event)
      |> Repo.all()

    render(
      conn,
      "index.html",
      current_memberships: current_memberships,
      event: event,
      locked_tasks: locked_tasks,
      unlocked_tasks: unlocked_tasks
    )
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

    next_task = get_next_task(event, task)
    previous_task = get_previous_task(event, task)
    next_unlockable_task =
      if is_nil(next_task) do
        get_next_unlockable_task(event, task)
      end

    if is_nil(task.unlocked_at) && !has_permission?(current_memberships, [1, 2]) do
      conn
      |> put_flash(:error, "Permission denied!")
      |> redirect(to: "/")
    else
      render(
        conn,
        "show.html",
        current_memberships: current_memberships,
        event: event,
        next_task: next_task,
        next_unlockable_task: next_unlockable_task,
        previous_task: previous_task,
        task: task
      )
    end
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
    |> Task.locked()
    |> Repo.update_all([set: [unlocked_at: DateTime.now_utc()]])

    page_reload_broadcast!([:event, event.id, :task, :unlock])

    conn
    |> put_flash(:info, "Tasks successfully unlocked.")
    |> redirect(to: classroom_task_path(conn, :index, event))
  end

  def lock_all(conn, _params) do
    event = current_event(conn)

    event
    |> assoc(:tasks)
    |> Task.unlocked()
    |> Repo.update_all([set: [unlocked_at: nil]])

    page_reload_broadcast!([:event, event.id, :task, :lock])

    conn
    |> put_flash(:info, "Tasks successfully locked.")
    |> redirect(to: classroom_task_path(conn, :index, event))
  end

  def unlock_next(conn, _params) do
    event = current_event(conn)

    task_res = event
    |> assoc(:tasks)
    |> Task.locked()
    |> Query.order_by(asc: :position)
    |> Query.first
    |> Repo.one()

    case task_res do
      %Task{} = task ->
        task
        |> Changeset.change(%{unlocked_at: DateTime.now_utc()})
        |> Repo.update!()

        page_reload_broadcast!([:event, event.id, :task, :unlock])

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
      if task.unlocked_at do
        %{unlocked_at: nil}
      else
        %{unlocked_at: DateTime.now_utc()}
      end

    task
    |> Changeset.change(updates)
    |> Repo.update!()

    if task.unlocked_at do
      page_reload_broadcast!([:event, event.id, :task, :lock])
    else
      page_reload_broadcast!([:event, event.id, :task, :unlock])
    end

    flash =
      if task.unlocked_at do
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
  defp get_next_task(%Event{}, %Task{unlocked_at: unlocked_at}) when is_nil(unlocked_at), do: nil
  defp get_next_task(%Event{} = event, %Task{} = task) do
    next_task =
      event
      |> assoc(:tasks)
      |> Task.unlocked()
      |> Query.where(unlocked_at: ^task.unlocked_at)
      |> Task.next_via_position(task)
      |> Repo.one()

    if next_task do
      next_task
    else
      event
      |> assoc(:tasks)
      |> Task.unlocked()
      |> Task.next_via_unlocked_at(task)
      |> Repo.one()
    end
  end

  defp get_previous_task(%Event{}, %Task{unlocked_at: unlocked_at}) when is_nil(unlocked_at), do: nil
  defp get_previous_task(%Event{} = event, %Task{} = task) do
    next_task =
      event
      |> assoc(:tasks)
      |> Task.unlocked()
      |> Query.where(unlocked_at: ^task.unlocked_at)
      |> Task.previous_via_position(task)
      |> Repo.one()

    if next_task do
      next_task
    else
      event
      |> assoc(:tasks)
      |> Task.unlocked()
      |> Task.previous_via_unlocked_at(task)
      |> Repo.one()
    end
  end

  defp get_next_unlockable_task(%Event{}, %Task{unlocked_at: unlocked_at}) when is_nil(unlocked_at), do: nil
  defp get_next_unlockable_task(%Event{} = event, %Task{} = task) do
    event
    |> assoc(:tasks)
    |> Task.locked()
    |> Task.next_via_position(task)
    |> Repo.one()
  end
end

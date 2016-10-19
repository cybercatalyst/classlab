defmodule Classlab.Classroom.TaskController do
  alias Classlab.{Event, Repo, Task}
  use Classlab.Web, :controller

  plug :scrub_params, "task" when action in [:create, :update]

  def index(conn, _params) do
    event = load_event(conn)
    tasks =
      event
      |> assoc(:tasks)
      |> Repo.all()

    render(conn, "index.html", event: event, tasks: tasks)
  end

  def new(conn, _params) do
    event = load_event(conn)
    changeset = Task.changeset(%Task{})

    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"task" => task_params}) do
    event = load_event(conn)
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
    event = load_event(conn)
    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)

    changeset = Task.changeset(task)

    render(conn, "edit.html", event: event, changeset: changeset, task: task)
  end

  def show(conn, %{"id" => task_id}) do
    event = load_event(conn)
    task =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)

    render(conn, "show.html", event: event, task: task)
  end

  def update(conn, %{"id" => task_id, "task" => task_params}) do
    event = load_event(conn)
    changeset =
      event
      |> assoc(:tasks)
      |> Repo.get!(task_id)
      |> Task.changeset(task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: classroom_task_path(conn, :show, event, task))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => task_id}) do
    event = load_event(conn)
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
  defp load_event(conn) do
    Event
    |> Repo.get_by!(slug: conn.params["event_id"])
    |> Repo.preload(:location)
  end
end

defmodule Classlab.Classroom.FeedbackController do
  @moduledoc false
  alias Classlab.{Event, Feedback}
  alias Ecto.{Query}
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  plug :restrict_roles, [3] when action in [:update, :edit, :new, :create]
  plug :restrict_roles, [1, 2] when action in [:index]

  def index(conn, _params) do
    event = current_event(conn)
    feedbacks =
      event
      |> assoc(:feedbacks)
      |> Repo.all()

    render(conn, "index.html", feedbacks: feedbacks)
  end

  def show(conn, _params) do
    event = current_event(conn)
    current_user = current_user(conn)

    feedback =
      current_user
      |> assoc(:feedbacks)
      |> Query.where(event_id: ^event.id)
      |> Repo.one()

    res =
      Event
      |> Event.not_feedbacked_by_user(current_user(conn))
      |> Event.within_feedback_period()
      |> Repo.get(event.id)

    can_give_feedback = !is_nil(res)

    render(conn, "show.html", event: event, feedback: feedback, can_give_feedback: can_give_feedback)
  end

  def new(conn, _params) do
    event = current_event(conn)

    Event
    |> Event.not_feedbacked_by_user(current_user(conn))
    |> Event.within_feedback_period()
    |> Repo.get!(event.id)

    changeset = Feedback.changeset(%Feedback{})
    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"feedback" => feedback_params}) do
    event = current_event(conn)

    Event
    |> Event.not_feedbacked_by_user(current_user(conn))
    |> Event.within_feedback_period()
    |> Repo.get!(event.id)

    changeset = Feedback.changeset(%Feedback{user: current_user(conn), event: event}, feedback_params)

    case Repo.insert(changeset) do
      {:ok, _feedback} ->
        conn
        |> put_flash(:info, "Feedback created successfully.")
        |> redirect(to: classroom_feedback_path(conn, :show, event))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, event: event)
    end
  end

  def edit(conn, _params) do
    event = current_event(conn)

    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Query.preload(:event)
      |> Repo.one!()

    changeset = Feedback.changeset(feedback)
    render(conn, "edit.html", feedback: feedback, changeset: changeset, event: event)
  end

  def update(conn, %{"feedback" => feedback_params}) do
    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Query.preload(:event)
      |> Repo.one!()

    changeset = Feedback.changeset(feedback, feedback_params)

    case Repo.update(changeset) do
      {:ok, feedback} ->
        conn
        |> put_flash(:info, "Feedback updated successfully.")
        |> redirect(to: classroom_feedback_path(conn, :show, feedback.event))
      {:error, changeset} ->
        render(conn, "edit.html", feedback: feedback, changeset: changeset, event: feedback.event)
    end
  end

  def delete(conn, _params) do
    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Query.preload(:event)
      |> Repo.one!()

    Repo.delete!(feedback)

    conn
    |> put_flash(:info, "Feedback deleted successfully.")
    |> redirect(to: classroom_feedback_path(conn, :show, feedback.event))
  end

  # Private methods
end

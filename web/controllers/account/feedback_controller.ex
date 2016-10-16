defmodule Classlab.Account.FeedbackController do
  alias Classlab.Feedback
  use Classlab.Web, :controller

  plug :scrub_params, "feedback" when action in [:create, :update]

  def index(conn, _params) do
    feedbacks =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Repo.all()

    render(conn, "index.html", feedbacks: feedbacks)
  end

  def new(conn, _params) do
    changeset = Feedback.changeset(%Feedback{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"feedback" => feedback_params}) do
    changeset = Feedback.changeset(%Feedback{user: current_user(conn)}, feedback_params)

    case Repo.insert(changeset) do
      {:ok, _feedback} ->
        conn
        |> put_flash(:info, "Feedback created successfully.")
        |> redirect(to: account_feedback_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Repo.get!(id)

    render(conn, "show.html", feedback: feedback)
  end

  def edit(conn, %{"id" => id}) do
    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Repo.get!(id)

    changeset = Feedback.changeset(feedback)
    render(conn, "edit.html", feedback: feedback, changeset: changeset)
  end

  def update(conn, %{"id" => id, "feedback" => feedback_params}) do
    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Repo.get!(id)

    changeset = Feedback.changeset(feedback, feedback_params)

    case Repo.update(changeset) do
      {:ok, feedback} ->
        conn
        |> put_flash(:info, "Feedback updated successfully.")
        |> redirect(to: account_feedback_path(conn, :show, feedback))
      {:error, changeset} ->
        render(conn, "edit.html", feedback: feedback, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    feedback =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Repo.get!(id)

    Repo.delete!(feedback)

    conn
    |> put_flash(:info, "Feedback deleted successfully.")
    |> redirect(to: account_feedback_path(conn, :index))
  end
end

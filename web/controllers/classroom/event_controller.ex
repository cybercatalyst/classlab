defmodule Classlab.Classroom.EventController do
  @moduledoc false
  alias Classlab.Event
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  plug :scrub_params, "event" when action in [:create, :update]
  plug :restrict_roles, [1]

  def edit(conn, _params) do
    event = load_event(conn)
    changeset = Event.changeset(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"event" => event_params}) do
    event = load_event(conn)
    changeset = Event.changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: classroom_event_path(conn, :edit, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    event = load_event(conn)
    Repo.delete!(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: account_event_path(conn, :index))
  end

  # Private methods
  defp load_event(conn) do
    conn
    |> current_event
    |> Repo.preload(:location)
  end
end

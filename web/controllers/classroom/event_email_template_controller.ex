defmodule Classlab.Classroom.EventEmailTemplateController do
  @moduledoc false
  alias Classlab.Event
  use Classlab.Web, :controller

  plug :scrub_params, "event" when action in [:create, :update]
  plug :restrict_roles, [1]

  def edit(conn, _params) do
    event = load_event(conn)
    changeset = Event.email_template_changeset(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"event" => event_params}) do
    event = load_event(conn)
    changeset = Event.email_template_changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Email Templates updated successfully.")
        |> redirect(to: classroom_event_email_template_path(conn, :edit, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  # Private methods
  defp load_event(conn) do
    conn
    |> current_event()
    |> Repo.preload(:location)
  end
end

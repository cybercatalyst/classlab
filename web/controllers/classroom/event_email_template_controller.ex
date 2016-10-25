defmodule Classlab.Classroom.EventEmailTemplateController do
  @moduledoc false
  alias Classlab.{Event, Membership, MembershipMailer}
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

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
        |> put_flash(:notice, "Email Templates updated successfully.")
        |> redirect(to: classroom_event_email_template_path(conn, :edit, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def send_test_email(conn, %{"before" => _}) do
    event = load_event(conn)

    Membership
    |> Repo.get_by!(user_id: current_user(conn).id, event_id: event.id)
    |> Repo.preload([:event, :user])
    |> MembershipMailer.before_event_email()
    |> Mailer.deliver_now()

    conn
    |> put_flash(:notice, "Test email has been sent to you.")
    |> redirect(to: classroom_event_email_template_path(conn, :edit, event))
  end
  def send_test_email(conn, %{"after" => _}) do
    event = load_event(conn)

    Membership
    |> Repo.get_by!(user_id: current_user(conn).id, event_id: event.id)
    |> Repo.preload([:event, :user])
    |> MembershipMailer.after_event_email()
    |> Mailer.deliver_now()

    conn
    |> put_flash(:notice, "Test email has been sent to you.")
    |> redirect(to: classroom_event_email_template_path(conn, :edit, event))
  end

  # Private methods
  defp load_event(conn) do
    conn
    |> current_event()
    |> Repo.preload(:location)
  end
end

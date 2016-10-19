defmodule Classlab.Classroom.InvitationController do
  @moduledoc false
  alias Classlab.{Event, Invitation, InvitationMailer}
  use Classlab.Web, :controller

  plug :scrub_params, "invitation" when action in [:create, :update]

  def index(conn, _params) do
    event = load_event(conn)
    invitations =
      event
      |> assoc(:invitations)
      |> Repo.all()
      |> Repo.preload(:event)

    render(conn, "index.html", invitations: invitations, event: event)
  end

  def new(conn, _params) do
    event = load_event(conn)
    changeset =
      event
      |> build_assoc(:invitations)
      |> Invitation.changeset()

    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"invitation" => invitation_params}) do
    event = load_event(conn)
    changeset =
      event
      |> build_assoc(:invitations, %{role_id: 3})
      |> Invitation.changeset(invitation_params)

    case Repo.insert(changeset) do
      {:ok, invitation} ->
        invitation
        |> Repo.preload(:event)
        |> InvitationMailer.invitation_email()
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: classroom_membership_path(conn, :index, event))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = load_event(conn)
    invitation =
      event
      |> assoc(:invitations)
      |> Repo.get!(id)

    Repo.delete!(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: classroom_membership_path(conn, :index, event))
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

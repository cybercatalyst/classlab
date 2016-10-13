defmodule Classlab.InvitationController do
  alias Classlab.{Event, Invitation}
  use Classlab.Web, :controller

  plug :scrub_params, "invitation" when action in [:create, :update]

  def index(conn, _params) do
    event = load_event(conn)
    invitations =
      event
      |> assoc(:invitations)
      |> Repo.all()

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
      |> build_assoc(:invitations)
      |> Invitation.changeset(invitation_params)

    case Repo.insert(changeset) do
      {:ok, _invitation} ->
        conn
        |> put_flash(:info, "Invitation created successfully.")
        |> redirect(to: event_invitation_path(conn, :index, event))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = load_event(conn)
    invitation =
      Invitation
      |> Repo.get!(id)

    render(conn, "show.html", invitation: invitation, event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = load_event(conn)
    invitation =
      Invitation
      |> Repo.get!(id)

    changeset = Invitation.changeset(invitation)
    render(conn, "edit.html", invitation: invitation, changeset: changeset, event: event)
  end

  def update(conn, %{"id" => id, "invitation" => invitation_params}) do
    event = load_event(conn)
    invitation =
      Invitation
      |> Repo.get!(id)

    changeset = Invitation.changeset(invitation, invitation_params)

    case Repo.update(changeset) do
      {:ok, invitation} ->
        conn
        |> put_flash(:info, "Invitation updated successfully.")
        |> redirect(to: event_invitation_path(conn, :show, event, invitation))
      {:error, changeset} ->
        render(conn, "edit.html", invitation: invitation, changeset: changeset, event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = load_event(conn)
    invitation =
      Invitation
      |> Repo.get!(id)

    Repo.delete!(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: event_invitation_path(conn, :index, event))
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

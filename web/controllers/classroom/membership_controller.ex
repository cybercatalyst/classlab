defmodule Classlab.Classroom.MembershipController do
  @moduledoc false
  alias Classlab.{Invitation, Membership}
  use Classlab.Web, :controller

   plug :restrict_roles, [1, 2] when action in [:delete]

  def index(conn, _params) do
    event = current_event(conn)
    memberships =
      event
      |> assoc(:memberships)
      |> Membership.not_as_role(1)
      |> Repo.all()
      |> Repo.preload([:user, :role, :event])

    completed_invitations =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.completed()
      |> Repo.all()
      |> Repo.preload(:role)

    open_invitations =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.not_completed()
      |> Repo.all()
      |> Repo.preload(:role)

    invitation_changeset =
      event
      |> build_assoc(:invitations)
      |> Invitation.changeset()

    render(
      conn,
      "index.html",
      event: event,
      invitation_changeset: invitation_changeset,
      memberships: memberships,
      completed_invitations: completed_invitations,
      open_invitations: open_invitations
    )
  end

  def delete(conn, %{"id" => id}) do
    event = current_event(conn)
    membership =
      event
      |> assoc(:memberships)
      |> Repo.get!(id)

    Repo.delete!(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: classroom_membership_path(conn, :index, event))
  end

  # Private methods
end

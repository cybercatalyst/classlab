defmodule Classlab.Account.MembershipController do
  @moduledoc false
  alias Classlab.{Invitation, Membership}
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  def index(conn, _params) do
    user =
      current_user(conn)

    memberships =
      user
      |> assoc(:memberships)
      |> Membership.not_as_role(1)
      |> Repo.all()
      |> Repo.preload([:event, :user, :role])

    open_invitations =
      Invitation
      |> Invitation.filter_by_email(user)
      |> Invitation.not_completed()
      |> Repo.all()
      |> Repo.preload([:event, :role])

    owner_memberships =
      user
      |> assoc(:memberships)
      |> Membership.as_role(1)
      |> Repo.all()
      |> Repo.preload([:event, :user, :role])

    render(
      conn,
      "index.html",
      memberships: memberships,
      open_invitations: open_invitations,
      owner_memberships: owner_memberships
    )
  end

  def delete(conn, %{"id" => id}) do
    membership =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.not_as_role(1)
      |> Repo.get!(id)

    Repo.delete!(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: account_membership_path(conn, :index))
  end
end

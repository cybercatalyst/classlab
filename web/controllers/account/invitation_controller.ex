defmodule Classlab.Account.InvitationController do
  alias Classlab.Invitation
  use Classlab.Web, :controller

  def index(conn, _params) do
    invitations =
      Invitation
      |> Invitation.from_user(current_user(conn))
      |> Repo.all()
      |> Repo.preload(:event)

    render(conn, "index.html", invitations: invitations)
  end

  def delete(conn, %{"id" => id}) do
    invitation =
      Invitation
      |> Invitation.from_user(current_user(conn))
      |> Repo.get!(id)

    Repo.delete!(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: account_invitation_path(conn, :index))
  end
end

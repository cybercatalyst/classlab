defmodule Classlab.Account.InvitationController do
  alias Classlab.Invitation
  use Classlab.Web, :controller

  def delete(conn, %{"id" => id}) do
    invitation =
      Invitation
      |> Invitation.filter_by_email(current_user(conn))
      |> Invitation.not_completed()
      |> Repo.get!(id)

    Repo.delete!(invitation)

    conn
    |> put_flash(:info, "Invitation deleted successfully.")
    |> redirect(to: account_membership_path(conn, :index, active_tab: "open_invitations"))
  end
end

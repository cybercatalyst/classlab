defmodule Classlab.Account.InvitationController do
  @moduledoc false
  alias Classlab.Invitation
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

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

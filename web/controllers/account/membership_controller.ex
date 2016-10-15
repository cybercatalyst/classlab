defmodule Classlab.Account.MembershipController do
  use Classlab.Web, :controller

  def index(conn, _params) do
    memberships =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Repo.all()
      |> Repo.preload([:user, :role, :event])

    render(conn, "index.html", memberships: memberships)
  end

  def delete(conn, %{"id" => id}) do
    membership =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Repo.get!(id)

    Repo.delete!(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: account_membership_path(conn, :index))
  end
end

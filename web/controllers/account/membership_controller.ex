defmodule Classlab.Account.MembershipController do
  alias Classlab.Membership
  use Classlab.Web, :controller

  def index(conn, _params) do
    memberships =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.not_as_role(1)
      |> Repo.all()
      |> Repo.preload([:user, :role, :event])

    render(conn, "index.html", memberships: memberships)
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

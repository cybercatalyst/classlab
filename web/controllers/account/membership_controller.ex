defmodule Classlab.Account.MembershipController do
  @moduledoc false
  alias Classlab.{Invitation, Membership}
  alias Ecto.Query
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  def index(conn, params) do
    user =
      current_user(conn)

    memberships =
      user
      |> assoc(:memberships)
      |> Membership.as_role(params["role_id"])
      |> Repo.all()
      |> Repo.preload([:event, :user, :role])

    render(conn, "index.html", memberships: memberships, memberships: memberships)
  end

  def delete(conn, %{"id" => id}) do
    membership =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.not_as_role(1)
      |> Repo.get!(id)
      |> Repo.preload(:user)

    Repo.delete!(membership)

    invitation =
      Invitation
      |> Query.where(email: ^membership.user.email)
      |> Query.where(event_id: ^membership.event_id)
      |> Repo.one()

    if invitation do
      Repo.delete!(invitation)
    end

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: account_membership_path(conn, :index))
  end
end

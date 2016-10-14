defmodule Classlab.MembershipController do
  alias Classlab.Membership
  use Classlab.Web, :controller

  plug :scrub_params, "membership" when action in [:create, :update]

  def index(conn, _params) do
    memberships =
      Membership
      |> Repo.all()

    render(conn, "index.html", memberships: memberships)
  end

  def new(conn, _params) do
    changeset = Membership.changeset(%Membership{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"membership" => membership_params}) do
    changeset = Membership.changeset(%Membership{}, membership_params)

    case Repo.insert(changeset) do
      {:ok, _membership} ->
        conn
        |> put_flash(:info, "Membership created successfully.")
        |> redirect(to: membership_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership =
      Membership
      |> Repo.get!(id)

    Repo.delete!(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: membership_path(conn, :index))
  end
end

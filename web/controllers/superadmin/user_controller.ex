defmodule Classlab.Superadmin.UserController do
  @moduledoc false
  alias Classlab.User
  use Classlab.Web, :controller

  plug :scrub_params, "user" when action in [:update]

  def index(conn, _params) do
    users =
      User
      |> User.admin_sort()
      |> Repo.all()

    render(conn, "index.html", users: users)
  end

  def edit(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)

    changeset = User.superadmin_changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user =
      User
      |> Repo.get!(id)

    changeset = User.superadmin_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: superadmin_user_path(conn, :edit, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user =
      User
      |> Repo.get!(id)

    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: superadmin_user_path(conn, :index))
  end
end

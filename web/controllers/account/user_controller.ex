defmodule Classlab.Account.UserController do
  @moduledoc false
  alias Classlab.User
  use Classlab.Web, :controller

  def edit(conn, _params) do
    user =
      current_user(conn)

    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user =
      current_user(conn)

    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: account_user_path(conn, :edit))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end

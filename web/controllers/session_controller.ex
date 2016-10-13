defmodule Classlab.SessionController do
  alias Classlab.Session
  use Classlab.Web, :controller

  def new(conn, _params) do
    changeset = Session.changeset(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    changeset = Session.changeset(%Session{}, session_params)
    render(conn, "new.html", changeset: changeset)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:error, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end

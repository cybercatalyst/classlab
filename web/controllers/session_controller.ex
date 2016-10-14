defmodule Classlab.SessionController do
  alias Classlab.{Session, UserMailer, User}
  use Classlab.Web, :controller

  def new(conn, _params) do
    changeset = Session.changeset(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    _changeset = Session.changeset(%Session{}, session_params)

    user_email = String.downcase(session_params["email"])
    user_struct =
      case Repo.get_by(User, email: user_email) do
        nil ->  User.registration_changeset(%User{email: user_email}, session_params)
        user -> User.registration_changeset(user, session_params)
      end

    case Repo.insert_or_update(user_struct) do
      {:ok, user} ->
        user
        |> UserMailer.token_email()
        |> Mailer.deliver_now()

        conn
        |> put_flash(:info, "We sent you a link to create an account. Please check your inbox.")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:error, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end

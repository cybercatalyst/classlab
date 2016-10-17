defmodule Classlab.SessionController do
  alias Classlab.{Repo, Session, UserMailer, User}
  alias Classlab.JWT.UserIdToken
  use Classlab.Web, :controller

  def show(conn, %{"id" => access_token}) when is_binary(access_token) do
    res =
      User
      |> User.with_valid_access_token()
      |> Repo.get_by(access_token: access_token)

    case res do
      %User{} = user ->
        conn
        |> put_session(:user_id_jwt, UserIdToken.encode(%UserIdToken{user_id: user.id}))
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: account_dashboard_path(conn, :show))
      nil ->
        conn
        |> put_flash(:error, "You link is not valid or expired. Please request a new link.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def new(conn, _params) do
    changeset = Session.changeset(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    user_email = normalize_email(session_params["email"])
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
    |> Session.logout()
    |> put_flash(:error, "Logged out.")
    |> redirect(to: page_path(conn, :index))
  end

  defp normalize_email(nil), do: ""
  defp normalize_email(email) when is_binary(email), do: String.downcase(email)
end

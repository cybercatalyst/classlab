defmodule Classlab.SessionController do
  alias Classlab.{Session, UserMailer, User}
  use Classlab.Web, :controller

  def show(conn, %{"id" => access_token}) when is_binary(access_token) do
    res =
      User
      |> User.with_valid_access_token()
      |> Repo.find_by(access_token: access_token)

    case res do
      %User{} = user ->
        IO.inspect "HAPPY BIRTHDAY ��"
        text conn, "123"
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
    user_email = unified_email(session_params["email"])
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

  defp unified_email(nil), do: ""
  defp unified_email(email) when is_binary(email), do: String.downcase(email)
end

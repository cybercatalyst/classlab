defmodule Classlab.AssignUserPlug do
  @moduledoc """
  Assigns the user to the connection by using the user_id_jwt stored in the session.

  If the jwt is invalid or not present then the user will be nil.
  """
  alias Classlab.{JWT.UserIdToken, Session, Repo, User}
  use Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    jwt = get_session(conn, :user_id_jwt)

    case get_user_by_jwt(jwt) do
      %User{} = user -> Session.login(conn, user)
      nil -> Session.logout(conn)
    end
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  # Private methods
  defp get_user_by_jwt(jwt) when is_binary(jwt) do
    case UserIdToken.decode(jwt) do
      %{"user_id" => user_id} -> Repo.get(User, user_id)
      _ -> nil
    end
  end
  defp get_user_by_jwt(_), do: nil
end

defmodule Classlab.AssignUserPlug do
  @moduledoc false
  use Phoenix.Controller
  alias Classlab.{JWT.UserIdToken, Repo, Router.Helpers, User}
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id_jwt = get_session(conn, :user_id_jwt)

    decode_jwt_token(conn, user_id_jwt)
  end

  defp decode_jwt_token(conn, nil) do assign_current_user(conn) end
  defp decode_jwt_token(conn, user_id_jwt) do
    case UserIdToken.decode(user_id_jwt) do
      %{"user_id" => user_id} ->
        assign_current_user(conn, user_id)
      _ ->
        delete_session(conn, :user_id_jwt)

        conn
        |> put_flash(:info, "Permission denied.")
        |> redirect(to: Helpers.session_path(conn, :new))
        |> halt
    end
  end
  defp assign_current_user(conn) do
    assign(conn, :current_user, nil)
  end
  defp assign_current_user(conn, user_id) do
    user = Repo.get(User, user_id)
    assign(conn, :current_user, user)
  end
end

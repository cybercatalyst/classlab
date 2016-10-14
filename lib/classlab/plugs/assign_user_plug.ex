defmodule Classlab.AssignUserPlug do
  @moduledoc false
  alias Classlab.{JWT, Repo, User}
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id_jwt = get_session(conn, :user_id_jwt)

    case JWT.UserIdToken.decode(user_id_jwt) do
      %{"user_id" => user_id} ->
        assign_current_user(conn, user_id)
      _ ->
        assign_current_user(conn, nil)
    end
  end

  defp assign_current_user(conn, nil) do
    assign(conn, :current_user, nil)
  end
  defp assign_current_user(conn, user_id) do
    user = Repo.get(User, user_id)
    assign(conn, :current_user, user)
  end
end

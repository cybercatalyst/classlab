defmodule Classlab.Session do
  @moduledoc """
  The session model encapsulates session handling. It can take an email address
  and an optional token.
  """
  alias Classlab.{User, JWT.UserIdToken}
  use Classlab.Web, :model

  # Fields
  schema "" do
    field :email, :string
  end

  # Changesets & Validations
  @fields [:email]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:email])
  end

  def login(conn, %User{} = user) do
    conn
    |> Plug.Conn.assign(:current_user, user)
    |> Plug.Conn.put_session(:user_id_jwt, UserIdToken.encode(%UserIdToken{user_id: user.id}))
  end

  def logout(conn) do
    conn
    |> Plug.Conn.delete_session(:user_id_jwt)
    |> Plug.Conn.assign(:current_user, nil)
  end
end

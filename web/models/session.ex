defmodule Classlab.Session do
  @moduledoc """
  The session model encapsulates session handling. It can take an email address
  and an optional token.
  """
  alias Plug.Conn
  alias Classlab.{User, JWT.UserToken}
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

  # Model Functions
  def login(%Conn{} = conn, %User{} = user) do
    conn
    |> Conn.assign(:current_user, user)
    |> Conn.put_session(:user_id_jwt, UserToken.encode(%UserToken{user_id: user.id}))
  end

  def logout(%Conn{} = conn) do
    conn
    |> Conn.delete_session(:user_id_jwt)
    |> Conn.assign(:current_user, nil)
  end
end

defmodule Classlab.AssignMembershipsPlug do
  @moduledoc """
  Assigns the current memberships of an user and event to the connection.
  """
  alias Classlab.{Membership, Repo}
  use Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_memberships: [%Membership{}]}} = conn, _opts), do: conn
  def call(conn, _opts) do

    current_user = conn.assigns[:current_user]
    current_event = conn.assigns[:current_event]

    if current_user && current_event do
      memberships =
        current_user
        |> Ecto.assoc(:memberships)
        |> Membership.for_event(current_event)
        |> Repo.all()
        |> Repo.preload(:role)

        assign(conn, :current_memberships, memberships)
    else
      conn
    end
  end

  def current_memberships(conn) do
    conn.assigns[:current_memberships]
  end

end

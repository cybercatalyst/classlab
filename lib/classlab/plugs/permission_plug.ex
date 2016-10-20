defmodule Classlab.PermissionPlug do
  @moduledoc """
  Provides api to check if user is loggedin or a superadmin.
  """
  alias Classlab.{Repo, Membership}
  alias Ecto
  alias Phoenix.Controller
  import Plug.Conn

  def restrict_roles(conn, roles) do
    unless roles do
      raise "Missing list of roles."
    end

    current_user = conn.assigns[:current_user]
    current_event = conn.assigns[:current_event]

    if current_user && current_event do
      matching_memberships_count =
        current_user
        |> Ecto.assoc(:memberships)
        |> Membership.for_event(current_event)
        |> Membership.as_roles(roles)
        |> Repo.aggregate(:count, :id)

      if matching_memberships_count > 0 do
        conn
      else
        handle_error(conn)
      end
    else
      handle_error(conn)
    end
  end

  def as_user(conn, _params) do
    current_user = conn.assigns[:current_user]

    if current_user do
      conn
    else
      handle_error(conn)
    end
  end

  def as_superadmin(conn, _params) do
    current_user = conn.assigns[:current_user]

    if current_user && current_user.superadmin do
      conn
    else
      handle_error(conn)
    end
  end

  defp handle_error(conn) do
    conn
    |> Controller.put_flash(:error, "Permission denied!")
    |> Controller.redirect(to: "/")
    |> halt()
  end
end

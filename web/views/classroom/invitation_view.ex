defmodule Classlab.Classroom.InvitationView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", conn), do: %{
    title: "New invitation",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Attendees",
      path: classroom_membership_path(conn, :index, conn.assigns.event)
    }, %{
      name: "New invitation"
    }]
  }

  # View functions
  def role_collection(roles) do
    roles
    |> Enum.map(&({"#{&1.name}", &1.id}))
  end
end

defmodule Classlab.InvitationView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", conn), do: %{
    title: "Get Invitation",
    breadcrumb: [%{
      name: "Events",
      path: event_path(conn, :index)
    }, %{
      name: conn.assigns.event.name,
      path: event_path(conn, :show, conn.assigns.event)
    }, %{
      name: "New invitation"
    }]
  }

  # View functions
end

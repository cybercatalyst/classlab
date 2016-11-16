defmodule Classlab.Classroom.EventView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("edit.html", conn), do: %{
    title: "Settings",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Settings"
    }]
  }

  # View functions
end

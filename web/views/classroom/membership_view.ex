defmodule Classlab.Classroom.MembershipView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", conn), do: %{
    title: "Attendees",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Attendees"
    }]
  }

  # View functions
end

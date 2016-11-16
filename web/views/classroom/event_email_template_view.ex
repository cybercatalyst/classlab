defmodule Classlab.Classroom.EventEmailTemplateView do
  @moduledoc false
  alias Classlab.Event
  use Classlab.Web, :view

  # Page Configuration
  def page("edit.html", conn), do: %{
    title: "E-Mail templates",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "E-Mail templates"
    }]
  }

  # View functions

end

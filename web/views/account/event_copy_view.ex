defmodule Classlab.Account.EventCopyView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", conn), do: %{
    title: "New event copy",
    breadcrumb: [%{
      name: "Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Copy event"
    }]
  }

  # View functions
end

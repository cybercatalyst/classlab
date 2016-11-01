defmodule Classlab.Account.EventView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", conn), do: %{
    title: "New event",
    breadcrumb: [%{
      name: "Event",
      path: account_membership_path(conn, :index)
    }, %{
      name: "New event"
    }]
  }

  # View functions
end

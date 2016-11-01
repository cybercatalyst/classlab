defmodule Classlab.Account.DashboardView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "Dashboard",
    breadcrumb: [%{
      name: "Dashboard"
    }]
  }

  # View functions
end

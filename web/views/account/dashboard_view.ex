defmodule Classlab.Account.DashboardView do
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "Account Dashboard"
  }

  # View functions
end

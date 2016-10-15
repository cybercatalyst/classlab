defmodule Classlab.Superadmin.DashboardView do
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "Superadmin Dashboard"
  }

  # View functions
end

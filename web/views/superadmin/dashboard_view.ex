defmodule Classlab.Superadmin.DashboardView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "Superadmin Dashboard"
  }

  # View functions
end

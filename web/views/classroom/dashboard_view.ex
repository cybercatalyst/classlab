defmodule Classlab.Classroom.DashboardView do
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "Classroom Dashboard"
  }

  # View functions
end

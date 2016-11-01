defmodule Classlab.Classroom.EventView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("edit.html", _conn), do: %{
    title: "Settings",
    breadcrumb: [%{
      name: "Settings"
    }]
  }

  # View functions
end

defmodule Classlab.Classroom.MaterialView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "materials"
  }
  def page("show.html", conn), do: %{
    title: "material #{conn.assigns.material.event_id}"
  }
  def page("new.html", _conn), do: %{
    title: "New material"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit material"
  }

  # View functions
end

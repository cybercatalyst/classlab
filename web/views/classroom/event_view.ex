defmodule Classlab.Classroom.EventView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("edit.html", _conn), do: %{
    title: "Edit event"
  }

  # View functions
end

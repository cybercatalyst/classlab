defmodule Classlab.EventView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "events"
  }
  def page("show.html", conn), do: %{
    title: "event #{conn.assigns.event.public}"
  }
  def page("new.html", _conn), do: %{
    title: "New event"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit event"
  }

  # View functions
end

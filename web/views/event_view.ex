defmodule Classlab.EventView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Events",
    breadcrumb: [%{
      name: "Events"
    }]
  }

  def page("show.html", conn), do: %{
    title: conn.assigns.event.name,
    breadcrumb: [%{
      name: "Events",
      path: event_path(conn, :index)
    }, %{
      name: conn.assigns.event.name
    }]
  }

  # View functions
end

defmodule Classlab.Classroom.MembershipView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Attendees",
    breadcrumb: [%{
      name: "Attendees"
    }]
  }

  # View functions
end

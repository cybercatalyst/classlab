defmodule Classlab.Classroom.MembershipView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "memberships"
  }

  # View functions
end

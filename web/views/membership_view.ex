defmodule Classlab.MembershipView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "memberships"
  }
  def page("show.html", conn), do: %{
    title: "membership #{conn.assigns.membership.user_id}"
  }
  def page("new.html", _conn), do: %{
    title: "New membership"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit membership"
  }

  # View functions
end

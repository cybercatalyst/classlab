defmodule Classlab.Account.MembershipView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "memberships"
  }
  def page("new.html", _conn), do: %{
    title: "New membership"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit membership"
  }

  # View functions
end

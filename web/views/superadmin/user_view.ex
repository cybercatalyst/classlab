defmodule Classlab.Superadmin.UserView do
  alias Classlab.User
  use Classlab.Web, :view

  # Page configuration
  def page("index.html", _conn), do: %{
    title: "User Liste"
  }
  def page("edit.html", conn), do: %{
    title: "#{conn.assigns.email}",
    noindex: true
  }

  # View functions
end

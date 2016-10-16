defmodule Classlab.Account.UserView do
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "User profile"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit User profile"
  }

  # View functions
end

defmodule Classlab.Account.UserView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("edit.html", _conn), do: %{
    title: "Edit User profile",
    breadcrumb: [%{
      name: "Profile",
    }]
  }

  # View functions
end

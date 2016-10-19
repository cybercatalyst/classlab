defmodule Classlab.Superadmin.UserView do
  @moduledoc false
  alias Classlab.User
  use Classlab.Web, :view

  # Page configuration
  def page("index.html", _conn), do: %{
    title: "User Liste"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit user",
    noindex: true
  }

  # View functions
end

defmodule Classlab.SessionView do
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", _conn), do: %{
    title: "Login"
  }
end

defmodule Classlab.Account.EventView do
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", _conn), do: %{
    title: "New event"
  }

  # View functions
end

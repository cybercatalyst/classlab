defmodule Classlab.Account.DashboardView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "My dashboard"
  }

  # View functions
end

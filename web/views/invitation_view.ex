defmodule Classlab.InvitationView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "invitation"
  }
  def page("new.html", _conn), do: %{
    title: "Complete invitation"
  }

  # View functions
end

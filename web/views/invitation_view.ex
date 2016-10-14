defmodule Classlab.InvitationView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "invitations"
  }
  def page("show.html", conn), do: %{
    title: "invitation #{conn.assigns.invitation.event_id}"
  }
  def page("new.html", _conn), do: %{
    title: "New invitation"
  }

  # View functions
end

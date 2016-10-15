defmodule Classlab.Classroom.InvitationView do
  alias Classlab.Invitation
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "invitations"
  }
  def page("new.html", _conn), do: %{
    title: "New invitation"
  }

  # View functions
end

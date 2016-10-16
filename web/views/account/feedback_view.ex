defmodule Classlab.Account.FeedbackView do
  use Classlab.Web, :view
  import Classlab.StarHelpers

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "feedbacks"
  }
  def page("show.html", conn), do: %{
    title: "feedback #{conn.assigns.feedback.event_id}"
  }
  def page("new.html", _conn), do: %{
    title: "New feedback"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit feedback"
  }

  # View functions
end

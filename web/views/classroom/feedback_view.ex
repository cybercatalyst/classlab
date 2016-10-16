defmodule Classlab.Classroom.FeedbackView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "feedbacks"
  }

  # View functions
end

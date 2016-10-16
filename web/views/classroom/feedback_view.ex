defmodule Classlab.Classroom.FeedbackView do
  use Classlab.Web, :view
  import Classlab.StarHelpers

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "feedbacks"
  }

  # View functions
end

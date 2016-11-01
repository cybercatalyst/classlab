defmodule Classlab.Classroom.FeedbackView do
  @moduledoc false
  use Classlab.Web, :view
  import Classlab.StarHelpers

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Feedbacks",
    breadcrumb: [%{
      name: "Feedbacks"
    }]
  }

  def page("show.html", _conn), do: %{
    title: "Feedback",
    breadcrumb: [%{
      name: "Feedback"
    }]
  }
  def page("new.html", conn), do: %{
    title: "New feedback",
    breadcrumb: [%{
      name: "Feedback",
      path: classroom_feedback_path(conn, :show, conn.assigns.event)
    }, %{
      name: "New feedback"
    }]
  }
  def page("edit.html", conn), do: %{
    title: "Edit feedback",
    breadcrumb: [%{
      name: "Feedback",
      path: classroom_feedback_path(conn, :show, conn.assigns.event)
    }, %{
      name: "Edit feedback"
    }]
  }

  # View functions
end

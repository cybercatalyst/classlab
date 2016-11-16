defmodule Classlab.Classroom.FeedbackView do
  @moduledoc false
  use Classlab.Web, :view
  import Classlab.StarHelpers

  # Page Configuration
  def page("index.html", conn), do: %{
    title: "Feedbacks",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Feedbacks"
    }]
  }

  def page("show.html", conn), do: %{
    title: "Feedback",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Feedback"
    }]
  }
  def page("new.html", conn), do: %{
    title: "New feedback",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Feedback",
      path: classroom_feedback_path(conn, :show, conn.assigns.event)
    }, %{
      name: "New feedback"
    }]
  }
  def page("edit.html", conn), do: %{
    title: "Edit feedback",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Feedback",
      path: classroom_feedback_path(conn, :show, conn.assigns.event)
    }, %{
      name: "Edit feedback"
    }]
  }

  # View functions
end

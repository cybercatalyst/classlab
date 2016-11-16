defmodule Classlab.Classroom.TaskView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", conn), do: %{
    title: "Tasks",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Tasks"
    }]
  }

  def page("new.html", conn), do: %{
    title: "New Task",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Tasks",
      path: classroom_task_path(conn, :index, conn.assigns.event)
    }, %{
      name: "New task"
    }]
  }

  def page("show.html", conn), do: %{
    title: conn.assigns.task.title,
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Tasks",
      path: classroom_task_path(conn, :index, conn.assigns.event)
    }, %{
      name: conn.assigns.task.title
    }]
  }

  def page("edit.html", conn), do: %{
    title: "Edit #{conn.assigns.task.title}",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Tasks",
      path: classroom_task_path(conn, :index, conn.assigns.event)
    }, %{
      name: conn.assigns.task.title,
      path: classroom_task_path(conn, :show, conn.assigns.event, conn.assigns.task)
    }, %{
      name: "Edit"
    }]
  }

  # View functions
end

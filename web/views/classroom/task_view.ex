defmodule Classlab.Classroom.TaskView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Tasks"
  }

  def page("new.html", _conn), do: %{
    title: "New Task"
  }

  def page("edit.html", _conn), do: %{
    title: "Update Task"
  }

  def page("show.html", _conn), do: %{
    title: "Task"
  }

  # View functions
end

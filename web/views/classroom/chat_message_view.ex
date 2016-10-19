defmodule Classlab.Classroom.ChatMessageView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "chat messages"
  }
  def page("new.html", _conn), do: %{
    title: "New chat message"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit chat message"
  }

  # View functions
end

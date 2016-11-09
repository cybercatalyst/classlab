defmodule Classlab.Classroom.ChatMessageView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Chat",
    breadcrumb: [%{
      name: "Chat"
    }]
  }
  def page("new.html", conn), do: %{
    title: "New chat message",
    breadcrumb: [%{
      name: "Chat",
      path: classroom_chat_message_path(conn, :index, conn.assigns.event)
    }, %{
      name: "New chat message"
    }]
  }
  def page("edit.html", conn), do: %{
    title: "Edit chat message",
    breadcrumb: [%{
      name: "Chat",
      path: classroom_chat_message_path(conn, :index, conn.assigns.event)
    }, %{
      name: "Edit chat message"
    }]
  }

  # View functions
  def is_trainer?(user, trainers) do
    Enum.any?(trainers, fn(trainer) -> trainer.user_id == user.id end)
  end
end

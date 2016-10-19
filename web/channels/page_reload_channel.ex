defmodule Classlab.PageReloadChannel do
  @moduledoc """
  Used for turbolinks to support interactive behaviour.
  The idea is that you can subscribe to any event on any page.
  Example:

  ### Controller
  ```
  page_reload_broadcast!([:event, event.id, :chat_message, :create])
  ```

  ### Template
  ```
  <%= page_reload_listener([:event, @event.id, :chat_message, :create]) %>
  ```
  """
  use Classlab.Web, :channel

  def join("page_reload:" <> _page, _payload, socket) do
    {:ok, socket} # allow everyone to join
  end

  def handle_in("reload", payload, socket) do
    broadcast socket, "reload", payload
    {:noreply, socket}
  end
end

defmodule Classlab.PageReloadHelpers do
  @moduledoc """
  Helps listening for page_reload events emitted in controllers.
  """
  use Phoenix.HTML

  def page_reload_listener(list) when is_list(list) do
    content_tag(:div, "", data: [page: [reload: Enum.join(list, ":")]])
  end
  def page_reload_listener(_), do: raise("Please pass a list, e.g. [:event, @event.id, :update]")
end

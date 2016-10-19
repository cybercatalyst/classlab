defmodule Classlab.Turbolinks.ControllerExtensions do
  @moduledoc """
  Adds function to broadcast a triggered event over a websocket.
  """
  alias Classlab.Endpoint

  def page_reload_broadcast!(args) do
    Endpoint.broadcast! "page_reload:#{Enum.join(args, ":")}", "reload", %{}
  end
end

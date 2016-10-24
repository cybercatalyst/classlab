defmodule Classlab.Account.EventCopyController do
  @moduledoc false
  alias Classlab.{Event, EventCopy}
  use Classlab.Web, :controller

  plug :scrub_params, "event_copy" when action in [:create]

  def show(conn, _params) do
    event = load_event(conn)
    changeset = EventCopy.changeset(%EventCopy{name: event.name})
    render(conn, "show.html", changeset: changeset, event: event)
  end

  # Private methods
  defp load_event(%{params: %{"event_id" => event_id}}) do
    Event
    |> Repo.get_by!(slug: event_id)
    |> Repo.preload(:location)
  end
end

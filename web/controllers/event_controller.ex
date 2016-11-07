defmodule Classlab.EventController do
  @moduledoc false
  alias Classlab.Event
  alias Ecto.Query
  use Classlab.Web, :controller

  def index(conn, _params) do
    events =
      Event
      |> Event.next_public()
      |> Query.preload(:location)
      |> Repo.all()

    render(conn, "index.html", events: events)
  end

  def show(conn, _params) do
    event = load_event(conn)

    render(conn, "show.html", event: event)
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["id"])
  end
end

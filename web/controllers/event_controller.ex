defmodule Classlab.EventController do
  @moduledoc false
  alias Classlab.Event
  alias Ecto.Query
  use Classlab.Web, :controller

  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

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

    if !event.public do
      conn
      |> put_flash(:error, "Permission denied")
      |> redirect(to: page_path(conn, :index))
    else
      render(conn, "show.html", event: event)
    end
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["id"])
  end
end

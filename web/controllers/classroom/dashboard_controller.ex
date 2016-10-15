defmodule Classlab.Classroom.DashboardController do
  alias Classlab.Event
  use Classlab.Web, :controller

  def show(conn, _params) do
    event = load_event(conn)
    render(conn, "show.html", event: event)
  end


  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

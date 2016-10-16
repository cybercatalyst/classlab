defmodule Classlab.Classroom.FeedbackController do
  alias Classlab.Event
  use Classlab.Web, :controller

  def index(conn, _params) do
    event = load_event(conn)
    feedbacks =
      event
      |> assoc(:feedbacks)
      |> Repo.all()

    render(conn, "index.html", feedbacks: feedbacks)
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

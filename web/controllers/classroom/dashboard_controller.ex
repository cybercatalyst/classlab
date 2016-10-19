defmodule Classlab.Classroom.DashboardController do
  @moduledoc false
  alias Classlab.{Event, Feedback}
  use Classlab.Web, :controller

  def show(conn, _params) do
    event = load_event(conn)

    feedback_averages =
      event
      |> assoc(:feedbacks)
      |> Feedback.averages()
      |> Repo.one()

    render(conn, "show.html", event: event, feedback_averages: feedback_averages)
  end


  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

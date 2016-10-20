defmodule Classlab.Classroom.FeedbackController do
  @moduledoc false
  use Classlab.Web, :controller

  plug :restrict_roles, [1, 2]

  def index(conn, _params) do
    event = current_event(conn)
    feedbacks =
      event
      |> assoc(:feedbacks)
      |> Repo.all()

    render(conn, "index.html", feedbacks: feedbacks)
  end

  # Private methods
end

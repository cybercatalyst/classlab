defmodule Classlab.Account.FeedbackController do
  @moduledoc false
  alias Classlab.{Event}
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  plug :scrub_params, "feedback" when action in [:create, :update]

  def index(conn, _params) do
    open_feedback_events =
      Event
      |> Event.not_feedbacked_by_user(current_user(conn))
      |> Event.within_feedback_period()
      |> Repo.all()

    feedbacks =
      conn
      |> current_user()
      |> assoc(:feedbacks)
      |> Repo.all()
      |> Repo.preload(:event)

    render(conn, "index.html", open_feedback_events: open_feedback_events, feedbacks: feedbacks)
  end
end

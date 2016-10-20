defmodule Classlab.Account.DashboardController do
  @moduledoc false
  alias Classlab.Event
  use Classlab.Web, :controller

  plug :as_user when action in [:show]

  def show(conn, _params) do
    user =
      current_user(conn)

    events_as_owner =
      Event
      |> Event.as_role(user, 1)
      |> Repo.all()

    events_as_attendee =
      Event
      |> Event.as_role(user, 3)
      |> Repo.all()

    render(conn, "show.html", user: user, events_as_owner: events_as_owner, events_as_attendee: events_as_attendee)
  end
end

defmodule Classlab.Account.DashboardController do
  @moduledoc false
  alias Classlab.{Event, Invitation}
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

    open_invitations =
      Invitation
      |> Invitation.filter_by_email(user)
      |> Invitation.not_completed()
      |> Repo.all()
      |> Repo.preload([:event, :role])

    render(conn, "show.html", user: user, events_as_owner: events_as_owner, events_as_attendee: events_as_attendee, open_invitations: open_invitations)
  end
end

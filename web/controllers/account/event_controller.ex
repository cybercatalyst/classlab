defmodule Classlab.Account.EventController do
  alias Classlab.{Event, Membership}
  use Classlab.Web, :controller

  plug :scrub_params, "event" when action in [:create, :update]

  def index(conn, _params) do
    user =
      current_user(conn)

    events =
      Event
      |> Event.as_role(user, 1)
      |> Repo.all()
      |> Repo.preload([:location, :invitations, :materials])

    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    changeset = Event.changeset(%Event{memberships: [%Membership{user: current_user(conn), role_id: 1}]}, event_params)

    case Repo.insert(changeset) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: account_event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end

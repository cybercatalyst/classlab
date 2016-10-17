defmodule Classlab.Account.EventController do
  alias Classlab.{Event, Membership}
  use Classlab.Web, :controller

  plug :scrub_params, "event" when action in [:create, :update]

  def index(conn, _params) do
    user =
      current_user(conn)

    events =
      Event
      |> Event.for_user(user)
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

  def show(conn, %{"id" => id}) do
    event =
      Event
      |> Repo.get_by!(slug: id)
      |> Repo.preload([:location, :memberships])

    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event =
      Event
      |> Repo.get_by!(slug: id)
      |> Repo.preload(:location)

    changeset = Event.changeset(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event =
      Event
      |> Repo.get_by!(slug: id)
      |> Repo.preload(:location)

    changeset = Event.changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: account_event_path(conn, :show, event))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event =
      Event
      |> Repo.get_by!(slug: id)

    Repo.delete!(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: account_event_path(conn, :index))
  end
end

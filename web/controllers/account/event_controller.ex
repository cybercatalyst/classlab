defmodule Classlab.Account.EventController do
  @moduledoc false
  alias Classlab.{Event, Membership}
  use Classlab.Web, :controller

  plug :scrub_params, "event" when action in [:create]

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    changeset = Event.changeset(%Event{memberships: [%Membership{user: current_user(conn), role_id: 1}]}, event_params)

    case Repo.insert(changeset) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: classroom_dashboard_path(conn, :show, event))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end

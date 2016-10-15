defmodule Classlab.Classroom.MembershipController do
  alias Classlab.Event
  use Classlab.Web, :controller

  def index(conn, _params) do
    event = load_event(conn)
    memberships =
      event
      |> assoc(:memberships)
      |> Repo.all()
      |> Repo.preload([:user, :role, :event])

    render(conn, "index.html", memberships: memberships)
  end

  def delete(conn, %{"id" => id}) do
    event = load_event(conn)
    membership =
      event
      |> assoc(:memberships)
      |> Repo.get!(id)

    Repo.delete!(membership)

    conn
    |> put_flash(:info, "Membership deleted successfully.")
    |> redirect(to: classroom_membership_path(conn, :index, event))
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

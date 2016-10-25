defmodule Classlab.PageController do
  @moduledoc false
  alias Classlab.Event
  alias Ecto.Query
  use Classlab.Web, :controller

  def index(conn, _params) do
    events =
      Event
      |> Event.next_public()
      |> Query.limit(5)
      |> Query.preload(:location)
      |> Repo.all()

    render(conn, "index.html", events: events)
  end
end

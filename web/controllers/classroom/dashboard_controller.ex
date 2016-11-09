defmodule Classlab.Classroom.DashboardController do
  @moduledoc false
  alias Classlab.{Feedback, Material, Membership, Task}
  alias Ecto.Query
  use Classlab.Web, :controller

  def show(conn, _params) do
    event = current_event(conn)

    feedback_averages =
      event
      |> assoc(:feedbacks)
      |> Feedback.averages()
      |> Repo.one()

    latest_unlocked_tasks =
      event
      |> assoc(:tasks)
      |> Task.unlocked()
      |> Query.order_by(desc: :inserted_at)
      |> Query.limit(5)
      |> Repo.all()

    latest_unlocked_materials =
      event
      |> assoc(:materials)
      |> Material.unlocked()
      |> Query.order_by(desc: :inserted_at)
      |> Query.order_by(desc: :inserted_at)
      |> Query.limit(5)
      |> Repo.all()

    latest_chat_messages =
      event
      |> assoc(:chat_messages)
      |> Query.order_by(desc: :inserted_at)
      |> Query.limit(5)
      |> Repo.all()
      |> Repo.preload(:user)

    latest_memberships =
      event
      |> assoc(:memberships)
      |> Membership.not_as_role(1)
      |> Query.order_by(desc: :inserted_at)
      |> Query.limit(5)
      |> Repo.all()
      |> Repo.preload([:user, :role])

    render(
      conn,
      "show.html",
      event: event,
      feedback_averages: feedback_averages,
      latest_unlocked_tasks: latest_unlocked_tasks,
      latest_unlocked_materials: latest_unlocked_materials,
      latest_chat_messages: latest_chat_messages,
      latest_memberships: latest_memberships
    )
  end

  # Private methods
end

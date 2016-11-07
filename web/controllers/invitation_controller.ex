defmodule Classlab.InvitationController do
  @moduledoc false
  alias Classlab.{Event, Invitation, InvitationMailer}
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  plug :scrub_params, "invitation" when action in [:create, :update]

  def new(conn, _params) do
    event = load_event(conn)

    if event.public do
      changeset =
        event
        |> build_assoc(:invitations)
        |> Invitation.changeset()

      render(conn, "new.html", changeset: changeset, event: event)
    else
      conn
      |> put_flash(:error, "Permission denied")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def create(conn, %{"invitation" => invitation_params}) do
    event = load_event(conn)

    if event.public do
      changeset =
        event
        |> build_assoc(:invitations, %{role_id: 3})
        |> Invitation.changeset(invitation_params)

      case Repo.insert(changeset) do
        {:ok, invitation} ->
          invitation
          |> Repo.preload(:event)
          |> InvitationMailer.invitation_email()
          |> Mailer.deliver_now()

          conn
          |> put_flash(:info, "We have sent you an invitation mail.")
          |> redirect(to: event_path(conn, :show, event))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset, event: event)
      end
    else
       conn
      |> put_flash(:error, "Permission denied")
      |> redirect(to: page_path(conn, :index))
    end
  end

  # Private methods
  defp load_event(%{params: %{"event_id" => event_id}}) do
    Event
    |> Repo.get_by!(slug: event_id)
    |> Repo.preload(:location)
  end
end

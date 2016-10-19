defmodule Classlab.InvitationController do
  @moduledoc false
  alias Classlab.{Repo, Event, Invitation, User, Membership}
  alias Ecto.Query
  use Classlab.Web, :controller

  def show(conn, %{"invitation_token" => invitation_token}) when is_binary(invitation_token) do
    event = load_event(conn);
    res =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.completed()
      |> Query.preload(:event)
      |> Repo.get_by(invitation_token: invitation_token)

    case res do
      %Invitation{} = invitation -> render(conn, "show.html", invitation: invitation)
      nil -> handle_error(conn, "Invalid invitation.")
    end
  end

  def new(conn, %{"invitation_token" => invitation_token}) do
    event = load_event(conn);
    res =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.not_completed()
      |> Repo.get_by(invitation_token: invitation_token)

    case res do
      %Invitation{} = invitation ->
        invitation = Repo.preload(invitation, :event)

        render(conn, "new.html", invitation: invitation)
      nil -> handle_error(conn, "Invalid invitation.")
    end
  end

  def create(conn, %{"invitation_token" => invitation_token}) do
    event = load_event(conn);
    invitation_res =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.not_completed()
      |> Query.preload(:event)
      |> Repo.get_by(invitation_token: invitation_token)

    case invitation_res do
      %Invitation{} = invitation ->
        user = create_user(invitation)
        if invitation_has_membership?(invitation, user) do
          handle_error(conn, "Already accepted the invitation.")
        else
          membership = create_membership(invitation, user)
          invitation_changeset = Invitation.completion_changeset(invitation, %{
            completed_at: membership.inserted_at
          })
          Repo.update!(invitation_changeset)

          redirect(conn, to: invitation_path(conn, :show, invitation.event.slug, invitation.invitation_token))
        end
      nil -> handle_error(conn, "Invalid invitation.")
    end
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_slug"])
  end

  defp handle_error(conn, flash_message) do
    conn
    |> put_flash(:error, flash_message)
    |> redirect(to: page_path(conn, :index))
  end

  defp create_user(%Invitation{} = invitation) do
    user_res =
      User
      |> Query.where(email: ^invitation.email)
      |> Repo.one()

    case user_res do
      %User{} = user ->
        user
      nil ->
        user_changeset = User.registration_changeset(%User{}, %{email: invitation.email})
        Repo.insert!(user_changeset)
    end
  end

  defp invitation_has_membership?(invitation, user) do
    membership_res =
      Membership
      |> Membership.for_event(invitation.event)
      |> Query.where(user_id: ^user.id)
      |> Query.where(role_id: ^invitation.role_id)
      |> Repo.one()

    case membership_res do
      %Membership{} = _ -> true
      nil -> false
    end
  end

  defp create_membership(invitation, user) do
    membership_changeset =
      user
      |> build_assoc(:memberships)
      |> Membership.changeset(%{
        event_id: invitation.event.id,
        role_id: invitation.role_id
      })

    Repo.insert!(membership_changeset)
  end
end

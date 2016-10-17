defmodule Classlab.InvitationController do
  alias Classlab.{Repo, Event, Invitation, User, Membership}
  alias Ecto.Query
  use Classlab.Web, :controller

  def show(conn, %{
    "invitation_token" => invitation_token
  }) when is_binary(invitation_token) do
    event = load_event(conn);
    res =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.completed()
      |> Query.preload(:event)
      |> Repo.get_by(invitation_token: invitation_token)

    case res do
      %Invitation{} = invitation ->
        conn
        |> put_flash(:info, "Invitation completed.")
        |> render("show.html", invitation: invitation)
      nil ->
        conn
        |> put_flash(:error, "Invalid invitation.")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def new(conn, %{
    "invitation_token" => invitation_token
  }) do
    event = load_event(conn);
    res =
      Invitation
      |> Invitation.for_event(event)
      |> Invitation.not_completed()
      |> Repo.get_by(invitation_token: invitation_token)

    case res do
      %Invitation{} = invitation ->
        invitation = Repo.preload(invitation, :event)

        conn
        |> render("new.html", invitation: invitation)
      nil ->
        conn
        |> put_flash(:error, "Invalid invitation.")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def create(conn, %{
    "invitation_token" => invitation_token
  }) do
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
        if has_membership?(event, invitation, user) do
          conn
          |> put_flash(:error, "Already accepted the invitation.")
          |> redirect(to: page_path(conn, :index))
        else
          membership = create_membership(invitation, user)
          invitation_changeset = Invitation.completion_changeset(invitation, %{
            completed_at: membership.inserted_at
          })
          Repo.update!(invitation_changeset)

          conn
          |> redirect(to: invitation_path(conn, :show, invitation.event.slug, invitation.invitation_token))
        end
      nil ->
        conn
        |> put_flash(:error, "Invalid invitation.")
        |> redirect(to: page_path(conn, :index))
    end
  end

  # Private methods
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_slug"])
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

  defp has_membership?(event, invitation, user) do
    membership_res =
      Membership
      |> Membership.for_event(event)
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

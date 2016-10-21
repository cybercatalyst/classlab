defmodule Classlab.Jobs.MembershipAfterEventEmailJob do
  @moduledoc """
  This Job gets called every once in a while (e. g. 30 min) and
  sends the after event email to all people who attended the event.
  """

  alias Classlab.{Event, Membership, MembershipMailer}
  alias Ecto.Query
  use Classlab.Web, :job

  def perform_now do
    events =
      Event
      |> Event.within_after_email_period()
      |> Repo.all()
      |> Enum.map(&(&1.id))

    attendee_memberships =
      Membership
      |> Membership.as_role(3)
      |> Membership.no_after_email_sent()
      |> Query.where([m], m.event_id in ^events)
      |> Query.preload([:user, :event])
      |> Repo.all()

    for membership <- attendee_memberships do
      Mailer.deliver_now MembershipMailer.after_event_email(membership)
      membership |> Membership.touch(:after_email_sent_at) |> Repo.update!()
    end
  end
end

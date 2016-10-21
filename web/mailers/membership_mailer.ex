defmodule Classlab.MembershipMailer do
  @moduledoc """
  Sends out emails when the membership to an event is created and
  when the event ended.
  """
  alias Classlab.{Endpoint, Membership, Event}
  use Classlab.Web, :mailer

  def before_event_email(%Membership{user: user, event: event}) do
    _classroom_link = classroom_dashboard_url(Endpoint, :show, event.slug)

    new_email
    |> to(user.email)
    |> from("me@example.com")
    |> subject(Event.before_email_subject(event))
    |> text_body(Event.before_email_body_text(event))
  end
end

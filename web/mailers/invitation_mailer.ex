defmodule Classlab.InvitationMailer do
  @moduledoc """
  Invitation mailer. Sends out emails when inviting new people to an event.
  """
  alias Classlab.{Invitation}
  use Classlab.Web, :mailer

  def invitation_email(%Invitation{email: email, first_name: _first_name, last_name: _last_name, event: event}) do
    new_email
    |> to(email)
    |> from("me@example.com")
    |> subject("Invitation to event #{event.name}")
    |> html_body("Todo")
  end
end

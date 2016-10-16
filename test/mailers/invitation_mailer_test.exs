defmodule Classlab.InvitationMailerTest do
  alias Classlab.InvitationMailer
  use Classlab.MailerCase

  test "#invitation_email" do
    invitation = Factory.build(:invitation)
    email = InvitationMailer.invitation_email(invitation)

    assert email.to == invitation.email
    assert email.html_body =~ invitation.invitation_token
    assert email.html_body =~ invitation.event.slug
  end
end

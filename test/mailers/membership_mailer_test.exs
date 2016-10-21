defmodule Classlab.MembershipMailerTest do
  alias Classlab.{MembershipMailer, Membership, Event, User}
  use Classlab.MailerCase

  describe "#before_event_email" do
    test "renders the default email text" do
      membership = %Membership{
        event: %Event{name: "Test Event", slug: "event-123"},
        user: %User{
          email: "user@example.com",
          first_name: "Martin",
          last_name: "Schurig"
        }
      }
      email = MembershipMailer.before_event_email(membership)

      assert email.to == membership.user.email
      assert email.subject == "#{membership.event.name}: A warm welcome"
      assert email.text_body =~ membership.user.first_name
      assert email.text_body =~ classroom_dashboard_path(Endpoint, :show, membership.event.slug)
    end

    test "renders the custom email text" do
      membership = %Membership{
        event: %Event{
          name: "Test Event",
          slug: "event-123",
          before_email_subject: "Custom Subject {{event_name}}",
          before_email_body_text: "Custom Text {{event_name}}"
        },
        user: %User{
          email: "user@example.com",
          first_name: "Martin",
          last_name: "Schurig"
        }
      }
      email = MembershipMailer.before_event_email(membership)

      assert email.to == membership.user.email
      assert email.subject == "Custom Subject #{membership.event.name}"
      assert email.text_body == "Custom Text #{membership.event.name}"
    end
  end

  describe "#after_event_email" do
    test "renders the default email text" do
      membership = %Membership{
        event: %Event{name: "Test Event", slug: "event-123"},
        user: %User{
          email: "user@example.com",
          first_name: "Martin",
          last_name: "Schurig"
        }
      }
      email = MembershipMailer.after_event_email(membership)

      assert email.to == membership.user.email
      assert email.subject == "#{membership.event.name}: Thanks for joining"
      assert email.text_body =~ membership.user.first_name
      assert email.text_body =~ membership.event.name
    end

    test "renders the custom email text" do
      membership = %Membership{
        event: %Event{
          name: "Test Event",
          slug: "event-123",
          after_email_subject: "Custom Subject {{event_name}}",
          after_email_body_text: "Custom Text {{event_name}}"
        },
        user: %User{
          email: "user@example.com",
          first_name: "Martin",
          last_name: "Schurig"
        }
      }
      email = MembershipMailer.after_event_email(membership)

      assert email.to == membership.user.email
      assert email.subject == "Custom Subject #{membership.event.name}"
      assert email.text_body == "Custom Text #{membership.event.name}"
    end
  end
end

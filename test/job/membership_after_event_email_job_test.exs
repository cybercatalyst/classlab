defmodule Classlab.Jobs.MembershipAfterEventEmailJobTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.{Jobs.MembershipAfterEventEmailJob, MembershipMailer}
  alias Calendar.DateTime

  use Classlab.JobCase

  describe "#perform_now" do
    test "sends emails to attendees (role_id 2)" do
      current_time = DateTime.now_utc()
      event = Factory.insert(:event, ends_at: DateTime.subtract!(current_time, 60 * 60))
      membership1 = Factory.insert(:membership, role_id: 1, event: event)
      membership2 = Factory.insert(:membership, role_id: 2, event: event)
      MembershipAfterEventEmailJob.perform_now()

      refute_delivered_email MembershipMailer.after_event_email(membership1)
      assert_delivered_email MembershipMailer.after_event_email(membership2)
    end
  end
end

defmodule Classlab.EventTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Event
  alias Calendar.DateTime
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:event)
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = Event.changeset(%Event{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with valid attributes and empty location" do
      changeset = Event.changeset(%Event{}, @valid_attrs |> Map.put(:location, %{"name" => nil}))
      assert changeset.errors == []
    end

# |> Map.put(:location, Factory.params_for(:location))
    test "with invalid attributes" do
      changeset = Event.changeset(%Event{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end

  describe "#within_feedback_period" do
    test "with correct events" do
      current_time = DateTime.now_utc()
      event_within = Factory.insert(:event, ends_at: current_time) # positive
      event_before = Factory.insert(:event, ends_at: DateTime.subtract!(current_time, 60 * 60 * 24 * 15)) # negative
      event_after = Factory.insert(:event, ends_at: DateTime.add!(current_time, 60 * 60)) # negative

      events =
        Event
        |> Event.within_feedback_period(current_time)
        |> Repo.all()

      assert length(events) == 1
      assert Enum.find(events, fn(e) -> e.id == event_within.id end)
      refute Enum.find(events, fn(e) -> e.id == event_before.id end)
      refute Enum.find(events, fn(e) -> e.id == event_after.id end)
    end
  end

  describe "#within_after_email_period" do
    test "only returns the correct memberships" do
      current_time = DateTime.now_utc()
      event_within = Factory.insert(:event, ends_at: current_time) # positive
      event_before = Factory.insert(:event, ends_at: DateTime.subtract!(current_time, 60 * 60 * 24 * 15)) # negative
      event_after = Factory.insert(:event, ends_at: DateTime.add!(current_time, 60 * 60)) # negative

      events =
        Event
        |> Event.within_after_email_period()
        |> Repo.all()

      assert length(events) == 1
      assert Enum.find(events, fn(e) -> e.id == event_within.id end)
      refute Enum.find(events, fn(e) -> e.id == event_before.id end)
      refute Enum.find(events, fn(e) -> e.id == event_after.id end)
    end
  end

  describe "#within_feedback_period?" do
    test "with event within period" do
      current_time = DateTime.now_utc()
      event = %Event{ends_at: current_time}
      assert Event.within_feedback_period?(event, current_time)
    end

    test "with event before period" do
      current_time = DateTime.now_utc()
      event = %Event{ends_at: DateTime.subtract!(current_time, 60 * 60 * 24 * 15)}
      refute Event.within_feedback_period?(event, current_time)
    end

    test "with event after period" do
      current_time = DateTime.now_utc()
      event = %Event{ends_at: DateTime.add!(current_time, 60 * 60)}
      refute Event.within_feedback_period?(event, current_time)
    end
  end
end

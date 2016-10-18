defmodule Classlab.EventTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Event
  alias Calendar.DateTime
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:event) |> Map.put(:location, Factory.params_for(:location))
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = Event.changeset(%Event{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Event.changeset(%Event{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end

  describe "#within_feedback_period" do
    test "with correct events" do
      event_within = Factory.insert(:event, ends_at: DateTime.now_utc) # positive
      event_before = Factory.insert(:event, ends_at: DateTime.subtract!(DateTime.now_utc, 60 * 60 * 24 * 15)) # negative
      event_after = Factory.insert(:event, ends_at: DateTime.add!(DateTime.now_utc, 60 * 60)) # negative

      events =
        Event
        |> Event.within_feedback_period()
        |> Repo.all()

      assert length(events) == 2
      assert Enum.find(events, fn(e) -> e.id == event_within.id end)
      refute Enum.find(events, fn(e) -> e.id == event_before.id end)
      refute Enum.find(events, fn(e) -> e.id == event_after.id end)
    end
  end

  describe "#within_feedback_period?" do
    test "with event within period" do
      event = %Event{ends_at: DateTime.now_utc()}
      assert Event.within_feedback_period?(event)
    end

    test "with event before period" do
      event = %Event{ends_at: DateTime.subtract!(DateTime.now_utc(), 60 * 60 * 24 * 15)}
      refute Event.within_feedback_period?(event)
    end

    test "with event after period" do
      event = %Event{ends_at: DateTime.add!(DateTime.now_utc(), 60 * 60)}
      refute Event.within_feedback_period?(event)
    end
  end
end

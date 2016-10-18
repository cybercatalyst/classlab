defmodule Classlab.EventTest do
  alias Classlab.Event
  alias Calendar.DateTime
  use Classlab.ModelCase

  @valid_attrs Factory.params_for(:event) |> Map.put(:location, Factory.params_for(:location))
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.errors == []
  end

  describe "#in_feedback_period" do
    test "returns the correct events" do
      event1 = Factory.insert(:event, ends_at: DateTime.now_utc) # positive
      event2 = Factory.insert(:event, ends_at: DateTime.subtract!(DateTime.now_utc, 60 * 60)) # positive
      event3 = Factory.insert(:event, ends_at: DateTime.add!(DateTime.now_utc, 60)) # negative
      event4 = Factory.insert(:event, ends_at: DateTime.subtract!(DateTime.now_utc, 60 * 60 * 24 * 15)) # negative

      events =
        Event
        |> Event.in_feedback_period()
        |> Repo.all()

      assert length(events) == 2
      assert Enum.find(events, fn(e) -> e.id == event1.id end)
      assert Enum.find(events, fn(e) -> e.id == event2.id end)
      refute Enum.find(events, fn(e) -> e.id == event3.id end)
      refute Enum.find(events, fn(e) -> e.id == event4.id end)
    end
  end
end

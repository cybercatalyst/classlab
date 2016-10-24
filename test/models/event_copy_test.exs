defmodule Classlab.EventCopyTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.EventCopy
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:event_copy)
    @invalid_attrs %{name: ""}

    test "with valid attributes" do
      changeset = EventCopy.changeset(%EventCopy{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = EventCopy.changeset(%EventCopy{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end

  describe "#copy_event" do
    @valid_event Factory.build(:event,
      materials: [Factory.build(:material)],
      tasks: [Factory.build(:task)]
    )

    test "copy only name" do
      # IO.inspect @valid_event
      event_copy = Factory.build(:event_copy, name: "New event name")
      result = EventCopy.copy_event(event_copy, @valid_event)
      refute Map.get(result, :id)
      assert Map.get(result, :name) == "New event name"
      refute Map.get(result, :tasks)
      refute Map.get(result, :materials)
    end

    test "copy tasks" do
      event_copy = Factory.build(:event_copy, copy_tasks: true)
      result = EventCopy.copy_event(event_copy, @valid_event)
      assert Map.get(result, :tasks)
    end

    test "copy materials" do
      event_copy = Factory.build(:event_copy, copy_materials: true)
      result = EventCopy.copy_event(event_copy, @valid_event)
      assert Map.get(result, :materials)
    end
  end
end

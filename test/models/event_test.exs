defmodule Classlab.EventTest do
  alias Classlab.Event
  use Classlab.ModelCase

  @valid_attrs Factory.params_for(:event)
               |> Map.put(:starts_at, "2000-06-24 00:04:09")
               |> Map.put(:ends_at, "2000-06-25 00:04:09")
               |> Map.put(:location, Factory.params_for(:location))
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

defmodule Classlab.EventTest do
  use Classlab.ModelCase

  alias Classlab.Event

  @valid_attrs %{description: "some content", ends_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, name: "some content", public: true, slug: "some content", starts_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, timezone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule Classlab.FeedbackTest do
  alias Classlab.Feedback
  use Classlab.ModelCase

  @valid_attrs %{content_comment: "some content", content_rating: 5, location_comment: "some content", location_rating: 5, testimonial: "some content", trainer_comment: "some content", trainer_rating: 5, event_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

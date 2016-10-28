defmodule Classlab.FeedbackTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Feedback
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs %{content_rating: 5, location_rating: 5, trainer_rating: 5}
    @invalid_attrs %{content_rating: -1}

    test "with valid attributes" do
      changeset = Feedback.changeset(%Feedback{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Feedback.changeset(%Feedback{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

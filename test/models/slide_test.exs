defmodule Classlab.SlideTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Slide
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:slide)
    @invalid_attrs %{url: ""}

    test "with valid attributes" do
      changeset = Slide.changeset(%Slide{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Slide.changeset(%Slide{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end
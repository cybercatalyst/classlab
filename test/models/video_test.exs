defmodule Classlab.VideoTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Video
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:video)
    @invalid_attrs %{url: ""}

    test "with valid attributes" do
      changeset = Video.changeset(%Video{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Video.changeset(%Video{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end
defmodule Classlab.TaskTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Task
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:task)
    @invalid_attrs %{title: ""}

    test "with valid attributes" do
      changeset = Task.changeset(%Task{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Task.changeset(%Task{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end
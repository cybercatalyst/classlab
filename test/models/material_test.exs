defmodule Classlab.MaterialTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.Material
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:material)
    @invalid_attrs %{url: ""}

    test "with valid attributes" do
      changeset = Material.changeset(%Material{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Material.changeset(%Material{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

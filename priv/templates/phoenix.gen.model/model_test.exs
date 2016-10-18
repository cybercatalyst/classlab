defmodule <%= module %>Test do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias <%= module %>
  use <%= base %>.ModelCase

  describe "#changeset" do
    @valid_attrs <%= inspect params %>
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = <%= alias %>.changeset(%<%= alias %>{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = <%= alias %>.changeset(%<%= alias %>{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

defmodule Classlab.RoleTest do
  alias Classlab.Role
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs %{name: "some content", description: "some content"}
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = Role.changeset(%Role{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = Role.changeset(%Role{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

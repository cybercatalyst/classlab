defmodule Classlab.MaterialTest do
  alias Classlab.Material
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs %{contents: %{}, name: "some content", type: 42, visible: true}
    @invalid_attrs %{}

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

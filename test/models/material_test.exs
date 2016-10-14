defmodule Classlab.MaterialTest do
  alias Classlab.Material
  use Classlab.ModelCase

  @valid_attrs %{contents: %{}, name: "some content", type: 42, visible: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Material.changeset(%Material{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Material.changeset(%Material{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

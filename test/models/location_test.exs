defmodule Classlab.LocationTest do
  alias Classlab.Location
  use Classlab.ModelCase

  @valid_attrs Factory.params_for(:location)
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

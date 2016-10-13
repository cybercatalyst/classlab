defmodule Classlab.LocationTest do
  alias Classlab.Location
  use Classlab.ModelCase

  @valid_attrs %{address_line_1: "some content", address_line_2: "some content", city: "some content", country: "some content", external_url: "some content", name: "some content", zipcode: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end
end

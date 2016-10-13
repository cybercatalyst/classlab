defmodule <%= module %>Test do
  alias <%= module %>
  use <%= base %>.ModelCase

  @valid_attrs <%= inspect params %>
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, @invalid_attrs)
    refute changeset.valid?
  end
end

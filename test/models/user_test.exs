defmodule Classlab.UserTest do
  alias Classlab.User
  use Classlab.ModelCase

  @valid_attrs Factory.params_for(:user)
  @invalid_attrs %{email: ""}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

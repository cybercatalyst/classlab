defmodule Classlab.UserTest do
  use Classlab.ModelCase

  alias Classlab.User

  @valid_attrs Factory.params_for(:user)
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

defmodule Classlab.UserTest do
  alias Classlab.User
  use Classlab.ModelCase

  @valid_attrs Factory.params_for(:user)
  @invalid_attrs %{email: ""}

  describe "#changeset" do
    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end

  describe "#registration_changeset" do
    test "with valid attributes" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = User.registration_changeset(%User{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

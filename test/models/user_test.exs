defmodule Classlab.UserTest do
  # BE A PRO! ONLY CREATE DATABASE OBJECTS WHERE NEEDED! PREFER SIMPLE STRUCTS!
  alias Classlab.User
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs Factory.params_for(:user)
    @invalid_attrs %{email: ""}

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
    @valid_attrs Factory.params_for(:user)
    @invalid_attrs %{email: ""}

    test "with valid attributes" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = User.registration_changeset(%User{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end

  describe "#full_name" do
    test "prints the full name with a valid user" do
      full_name = User.full_name(%User{first_name: "John", last_name: "Doe"})
      assert full_name == "John Doe"
    end

    test "prints an empty string otherwise" do
      full_name = User.full_name(%User{})
      assert full_name == ""
    end
  end
end

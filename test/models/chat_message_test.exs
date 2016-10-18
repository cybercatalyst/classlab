defmodule Classlab.ChatMessageTest do
  alias Classlab.ChatMessage
  use Classlab.ModelCase

  describe "#changeset" do
    @valid_attrs %{body: "some content"}
    @invalid_attrs %{}

    test "with valid attributes" do
      changeset = ChatMessage.changeset(%ChatMessage{}, @valid_attrs)
      assert changeset.errors == []
    end

    test "with invalid attributes" do
      changeset = ChatMessage.changeset(%ChatMessage{}, @invalid_attrs)
      refute changeset.errors == []
    end
  end
end

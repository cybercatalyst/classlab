defmodule Classlab.ChatMessageTest do
  alias Classlab.ChatMessage
  use Classlab.ModelCase

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ChatMessage.changeset(%ChatMessage{}, @valid_attrs)
    assert changeset.errors == []
  end

  test "changeset with invalid attributes" do
    changeset = ChatMessage.changeset(%ChatMessage{}, @invalid_attrs)
    refute changeset.errors == []
  end
end

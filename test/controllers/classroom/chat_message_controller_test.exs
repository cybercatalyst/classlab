defmodule Classlab.Classroom.ChatMessageControllerTest do
  alias Classlab.ChatMessage
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:chat_message) |> Map.take(~w[body]a)
  @invalid_attrs %{body: ""}
  @form_field "chat_message_body"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    event = Factory.insert(:event)
    Factory.insert(:membership, event: event, user: user)
    {:ok, conn: Session.login(conn, user), event: event}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn, event: event} do
      chat_message = Factory.insert(:chat_message, event: event)
      conn = get conn, classroom_chat_message_path(conn, :index, chat_message.event)
      assert html_response(conn, 200) =~ chat_message.body
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn, event: event} do
      conn = get conn, classroom_chat_message_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn, event: event} do
      conn = post conn, classroom_chat_message_path(conn, :create, event), chat_message: @valid_attrs
      assert redirected_to(conn) == "#{classroom_chat_message_path(conn, :index, event)}#last_message"
      assert Repo.get_by(ChatMessage, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn, event: event} do
      conn = post conn, classroom_chat_message_path(conn, :create, event), chat_message: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn, event: event} do
      chat_message = Factory.insert(:chat_message, event: event)
      conn = get conn, classroom_chat_message_path(conn, :edit, chat_message.event, chat_message)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn, event: event} do
      chat_message = Factory.insert(:chat_message, event: event)
      conn = put conn, classroom_chat_message_path(conn, :update, chat_message.event, chat_message), chat_message: @valid_attrs
      assert redirected_to(conn) == "#{classroom_chat_message_path(conn, :index, event)}#last_message"
      assert Repo.get_by(ChatMessage, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, event: event} do
      chat_message = Factory.insert(:chat_message, event: event)
      conn = put conn, classroom_chat_message_path(conn, :update, chat_message.event, chat_message), chat_message: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn, event: event} do
      chat_message = Factory.insert(:chat_message, event: event)
      conn = delete conn, classroom_chat_message_path(conn, :delete, chat_message.event, chat_message)
      assert redirected_to(conn) == "#{classroom_chat_message_path(conn, :index, event)}#last_message"
      refute Repo.get(ChatMessage, chat_message.id)
    end
  end
end

defmodule Classlab.Classroom.ChatMessageControllerTest do
  alias Classlab.ChatMessage
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:chat_message) |> Map.take(~w[body]a)
  @invalid_attrs %{body: ""}
  @form_field "chat_message_body"

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, conn: Session.login(conn, user)}
  end

  describe "#index" do
    test "lists all entries on index", %{conn: conn} do
      chat_message = Factory.insert(:chat_message)
      conn = get conn, classroom_chat_message_path(conn, :index, chat_message.event)
      assert html_response(conn, 200) =~ chat_message.body
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      event = Factory.insert(:event)
      conn = get conn, classroom_chat_message_path(conn, :new, event)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      event = Factory.insert(:event)
      conn = post conn, classroom_chat_message_path(conn, :create, event), chat_message: @valid_attrs
      assert redirected_to(conn) == classroom_chat_message_path(conn, :index, event)
      assert Repo.get_by(ChatMessage, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      event = Factory.insert(:event)
      conn = post conn, classroom_chat_message_path(conn, :create, event), chat_message: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#edit" do
    test "renders form for editing chosen resource", %{conn: conn} do
      chat_message = Factory.insert(:chat_message)
      conn = get conn, classroom_chat_message_path(conn, :edit, chat_message.event, chat_message)
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#update" do
    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      chat_message = Factory.insert(:chat_message)
      conn = put conn, classroom_chat_message_path(conn, :update, chat_message.event, chat_message), chat_message: @valid_attrs
      assert redirected_to(conn) == classroom_chat_message_path(conn, :index, chat_message.event)
      assert Repo.get_by(ChatMessage, @valid_attrs)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      chat_message = Factory.insert(:chat_message)
      conn = put conn, classroom_chat_message_path(conn, :update, chat_message.event, chat_message), chat_message: @invalid_attrs
      assert html_response(conn, 200) =~ @form_field
    end
  end

  describe "#delete" do
    test "deletes chosen resource", %{conn: conn} do
      chat_message = Factory.insert(:chat_message)
      conn = delete conn, classroom_chat_message_path(conn, :delete, chat_message.event, chat_message)
      assert redirected_to(conn) == classroom_chat_message_path(conn, :index, chat_message.event)
      refute Repo.get(ChatMessage, chat_message.id)
    end
  end
end

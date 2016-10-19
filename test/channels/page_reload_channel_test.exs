defmodule Classlab.PageReloadChannelTest do
  alias Classlab.PageReloadChannel
  use Classlab.ChannelCase

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(PageReloadChannel, "page_reload:event:1")
    {:ok, socket: socket}
  end

  describe "handle_in(:reload)" do
    test "shout broadcasts to page_Reload:lobby", %{socket: socket} do
      push socket, "reload", %{"hello" => "all"}
      assert_broadcast "reload", %{"hello" => "all"}
    end
  end
end

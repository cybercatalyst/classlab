defmodule Classlab.PageReloadHelpersTest do
  alias Classlab.PageReloadHelpers
  use Classlab.ConnCase, async: true

  describe "#page_reload_listener" do
    test "creation of div element from list" do
      html = PageReloadHelpers.page_reload_listener([:event, :create])
      assert Phoenix.HTML.safe_to_string(html) == "<div data-page-reload=\"event:create\"></div>"
    end

    test "error raise" do
      assert_raise RuntimeError, "Please pass a list, e.g. [:event, @event.id, :update]",  fn ->
        PageReloadHelpers.page_reload_listener("fail")
      end
    end
  end
end

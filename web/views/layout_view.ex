defmodule Classlab.LayoutView do
  @moduledoc false
  use Classlab.Web, :view

  def page(conn) do
    apply(view_module(conn), :page, [conn.private.phoenix_template, conn])
  end
end

defmodule Classlab.LayoutView do
  @moduledoc false
  use Classlab.Web, :view

  def page(conn) do
    apply(view_module(conn), :page, [conn.private.phoenix_template, conn])
  end

  def meta_jwt_session(conn) do
    jwt = Plug.Conn.get_session(conn, :user_id_jwt)
    tag(:meta, name: "session_token", content: jwt)
  end
end

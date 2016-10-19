defmodule Classlab.LayoutView do
  @moduledoc false
  alias Plug.Conn
  use Classlab.Web, :view

  def page(conn) do
    apply(view_module(conn), :page, [conn.private.phoenix_template, conn])
  end

  def meta_jwt_session(conn) do
    jwt = Conn.get_session(conn, :user_id_jwt)
    tag(:meta, name: "session_token", content: jwt)
  end
end

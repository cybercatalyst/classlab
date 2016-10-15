defmodule Classlab.UserHelpers do
  @moduledoc """
  Helpers to simplify access to connection assigsn.
  Example:
  <%= current_user(@conn) %>
  """
  def current_user(conn) do
    conn.assigns[:current_user]
  end
end

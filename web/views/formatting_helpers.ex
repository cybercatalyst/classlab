defmodule Classlab.FormattingHelpers do
  @moduledoc """
  Helpers to simplify form building.
  Example:
  <%= input f, :name %>
  """

  def truncate(str, length) when is_binary(str) do
    String.slice(str, 0, length) <> "..."
  end
end

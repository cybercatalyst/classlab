defmodule Classlab.MarkdownHelpers do
  @moduledoc """
  Helper to transform markdowm to html.
  """
  use Phoenix.HTML

  def render_markdown(nil), do: ""
  def render_markdown(input_md), do: raw(Earmark.to_html(input_md))
  def render_markdown(input_md, [escape: true]), do: render_markdown(safe_to_string(html_escape(input_md)))
end

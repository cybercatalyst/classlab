defmodule Classlab.StarHelpers do
  @moduledoc """
  Helper to print stars. Used in feedback_view from account and classroom.
  """
  use Phoenix.HTML

  def stars(n) when n == 1, do: [content_tag(:span, "★", class: "text-danger"),
                                 content_tag(:span, "☆☆☆☆", class: "text-muted")]
  def stars(n) when n == 2, do: [content_tag(:span, "★★", class: "text-danger"),
                                 content_tag(:span, "☆☆☆", class: "text-muted")]
  def stars(n) when n == 3, do: [content_tag(:span, "★★★", class: "text-warning"),
                                 content_tag(:span, "☆☆", class: "text-muted")]
  def stars(n) when n == 4, do: [content_tag(:span, "★★★★", class: "text-success"),
                                 content_tag(:span, "☆", class: "text-muted")]
  def stars(n) when n == 5, do: [content_tag(:span, "★★★★★", class: "text-success")]
end

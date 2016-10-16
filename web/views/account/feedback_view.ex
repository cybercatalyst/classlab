defmodule Classlab.Account.FeedbackView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "feedbacks"
  }
  def page("show.html", conn), do: %{
    title: "feedback #{conn.assigns.feedback.event_id}"
  }
  def page("new.html", _conn), do: %{
    title: "New feedback"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit feedback"
  }

  # View functions
  def stars(n) when n == 1, do: [content_tag(:span, "★", class: "text-danger"), content_tag(:span, "☆☆☆☆", class: "text-muted")]
  def stars(n) when n == 2, do: [content_tag(:span, "★★", class: "text-danger"), content_tag(:span, "☆☆☆", class: "text-muted")]
  def stars(n) when n == 3, do: [content_tag(:span, "★★★", class: "text-warning"), content_tag(:span, "☆☆", class: "text-muted")]
  def stars(n) when n == 4, do: [content_tag(:span, "★★★★", class: "text-success"), content_tag(:span, "☆", class: "text-muted")]
  def stars(n) when n == 5, do: [content_tag(:span, "★★★★★", class: "text-success")]
end

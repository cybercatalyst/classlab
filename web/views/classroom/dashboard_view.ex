defmodule Classlab.Classroom.DashboardView do
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", _conn), do: %{
    title: "Classroom Dashboard"
  }

  # View functions
  def format_rating(nil), do: ""
  def format_rating(rating) do
    Decimal.round(rating, 2, :half_up)
  end
end

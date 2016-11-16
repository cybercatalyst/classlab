defmodule Classlab.Classroom.DashboardView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("show.html", conn), do: %{
    title: "Dashboard",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Dashboard"
    }]
  }

  # View functions
  def format_rating(nil), do: ""
  def format_rating(rating) do
    rating
    |> Decimal.round(2, :half_up)
    |> Decimal.to_string
  end
end

defmodule Classlab.Superadmin.DashboardController do
  @moduledoc false
  use Classlab.Web, :controller

  def show(conn, _params) do
    render conn, "show.html"
  end
end

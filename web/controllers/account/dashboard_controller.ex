defmodule Classlab.Account.DashboardController do
  use Classlab.Web, :controller

  def show(conn, _params) do
    user =
      current_user(conn)

    render(conn, "show.html", user: user)
  end
end

defmodule Classlab.AssignUserPlugTest do
  use Classlab.ConnCase

  alias Classlab.AssignUserPlug

  test "#", %{conn: conn} do
    conn =
      conn
      |> AssignUserPlug.call(%{})

    refute conn.assigns[:current_user]
  end
end

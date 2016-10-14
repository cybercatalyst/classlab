defmodule Classlab.AssignUserPlugTest do
  use Classlab.ConnCase

  alias Classlab.AssignUserPlug

  test "#assign_domain_and_project_or_redirect gets the currect domain if NO domain cookie is set" do
    conn =
      build_conn(:get, "/")
      |> AssignUserPlug.decode_jwt_token(nil)

    assert is_nil(conn.assigns[:current_user])
  end
end

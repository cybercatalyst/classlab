defmodule <%= module %>ControllerTest do
  alias <%= module %>
  use <%= base %>.ConnCase

  @valid_attrs Factory.params_for(:<%= singular %>) |> Map.take(~w[<%= attrs |> Keyword.keys |> Enum.join(" ") %>]a)
  @invalid_attrs %{<%= attrs |> Enum.at(0) |> elem(0) %>: ""}
  @form_field "<%= singular %>_<%= attrs |> Enum.at(0) |> elem(0) %>"

  test "#index lists all entries on index", %{conn: conn} do
    <%= singular %> = Factory.insert(:<%= singular %>)
    conn = get conn, <%= singular %>_path(conn, :index)
    assert html_response(conn, 200) =~ <%= singular %>.<%= attrs |> Enum.at(0) |> elem(0) %>
  end

  test "#new renders form for new resources", %{conn: conn} do
    conn = get conn, <%= singular %>_path(conn, :new)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#create creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, <%= singular %>_path(conn, :create), <%= singular %>: @valid_attrs
    assert redirected_to(conn) == <%= singular %>_path(conn, :index)
    assert Repo.get_by(<%= alias %>, @valid_attrs)
  end

  test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, <%= singular %>_path(conn, :create), <%= singular %>: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#show shows chosen resource", %{conn: conn} do
    <%= singular %> = Factory.insert(:<%= singular %>)
    conn = get conn, <%= singular %>_path(conn, :show, <%= singular %>)
    assert html_response(conn, 200) =~ <%= singular %>.<%= attrs |> Enum.at(0) |> elem(0) %>
  end

  test "#show renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, <%= singular %>_path(conn, :show, -1)
    end
  end

  test "#edit renders form for editing chosen resource", %{conn: conn} do
    <%= singular %> = Factory.insert(:<%= singular %>)
    conn = get conn, <%= singular %>_path(conn, :edit, <%= singular %>)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#update updates chosen resource and redirects when data is valid", %{conn: conn} do
    <%= singular %> = Factory.insert(:<%= singular %>)
    conn = put conn, <%= singular %>_path(conn, :update, <%= singular %>), <%= singular %>: @valid_attrs
    assert redirected_to(conn) == <%= singular %>_path(conn, :show, <%= singular %>)
    assert Repo.get_by(<%= alias %>, @valid_attrs)
  end

  test "#update does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    <%= singular %> = Factory.insert(:<%= singular %>)
    conn = put conn, <%= singular %>_path(conn, :update, <%= singular %>), <%= singular %>: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    <%= singular %> = Factory.insert(:<%= singular %>)
    conn = delete conn, <%= singular %>_path(conn, :delete, <%= singular %>)
    assert redirected_to(conn) == <%= singular %>_path(conn, :index)
    refute Repo.get(<%= alias %>, <%= singular %>.id)
  end
end

defmodule Classlab.MaterialControllerTest do
  alias Classlab.Material
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:material) |> Map.take(~w[event_id visible name type contents]a)
  @invalid_attrs %{event_id: ""}
  @form_field "material_event_id"

  test "#index lists all entries on index", %{conn: conn} do
    material = Factory.insert(:material)
    conn = get conn, material_path(conn, :index)
    assert html_response(conn, 200) =~ material.event_id
  end

  test "#new renders form for new resources", %{conn: conn} do
    conn = get conn, material_path(conn, :new)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#create creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, material_path(conn, :create), material: @valid_attrs
    assert redirected_to(conn) == material_path(conn, :index)
    assert Repo.get_by(Material, @valid_attrs)
  end

  test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, material_path(conn, :create), material: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#show shows chosen resource", %{conn: conn} do
    material = Factory.insert(:material)
    conn = get conn, material_path(conn, :show, material)
    assert html_response(conn, 200) =~ material.event_id
  end

  test "#show renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, material_path(conn, :show, -1)
    end
  end

  test "#edit renders form for editing chosen resource", %{conn: conn} do
    material = Factory.insert(:material)
    conn = get conn, material_path(conn, :edit, material)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#update updates chosen resource and redirects when data is valid", %{conn: conn} do
    material = Factory.insert(:material)
    conn = put conn, material_path(conn, :update, material), material: @valid_attrs
    assert redirected_to(conn) == material_path(conn, :show, material)
    assert Repo.get_by(Material, @valid_attrs)
  end

  test "#update does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    material = Factory.insert(:material)
    conn = put conn, material_path(conn, :update, material), material: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    material = Factory.insert(:material)
    conn = delete conn, material_path(conn, :delete, material)
    assert redirected_to(conn) == material_path(conn, :index)
    refute Repo.get(Material, material.id)
  end
end

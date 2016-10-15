defmodule Classlab.Account.MaterialControllerTest do
  alias Classlab.Material
  use Classlab.ConnCase

  @valid_attrs Factory.params_for(:material) |> Map.take(~w[visible name type]a)
  @invalid_attrs %{name: ""}
  @form_field "material_name"

  test "#index lists all entries on index", %{conn: conn} do
    material = Factory.insert(:material)
    conn = get conn, account_event_material_path(conn, :index, material.event)
    assert html_response(conn, 200) =~ material.name
  end

  test "#new renders form for new resources", %{conn: conn} do
    event = Factory.insert(:event)
    conn = get conn, account_event_material_path(conn, :new, event)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#create creates resource and redirects when data is valid", %{conn: conn} do
    event = Factory.insert(:event)
    conn = post conn, account_event_material_path(conn, :create, event), material: @valid_attrs
    assert redirected_to(conn) == account_event_material_path(conn, :index, event)
    assert Repo.get_by(Material, @valid_attrs)
  end

  test "#create does not create resource and renders errors when data is invalid", %{conn: conn} do
    event = Factory.insert(:event)
    conn = post conn, account_event_material_path(conn, :create, event), material: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#show shows chosen resource", %{conn: conn} do
    material = Factory.insert(:material)
    conn = get conn, account_event_material_path(conn, :show, material.event, material)
    assert html_response(conn, 200) =~ material.name
  end

  test "#show renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, account_event_material_path(conn, :show, -1, -1)
    end
  end

  test "#edit renders form for editing chosen resource", %{conn: conn} do
    material = Factory.insert(:material)
    conn = get conn, account_event_material_path(conn, :edit, material.event, material)
    assert html_response(conn, 200) =~ @form_field
  end

  test "#update updates chosen resource and redirects when data is valid", %{conn: conn} do
    material = Factory.insert(:material)
    conn = put conn, account_event_material_path(conn, :update, material.event, material), material: @valid_attrs
    assert redirected_to(conn) == account_event_material_path(conn, :show, material.event, material)
    assert Repo.get_by(Material, @valid_attrs)
  end

  test "#update does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    material = Factory.insert(:material)
    conn = put conn, account_event_material_path(conn, :update, material.event, material), material: @invalid_attrs
    assert html_response(conn, 200) =~ @form_field
  end

  test "#delete deletes chosen resource", %{conn: conn} do
    material = Factory.insert(:material)
    conn = delete conn, account_event_material_path(conn, :delete, material.event, material)
    assert redirected_to(conn) == account_event_material_path(conn, :index, material.event)
    refute Repo.get(Material, material.id)
  end
end

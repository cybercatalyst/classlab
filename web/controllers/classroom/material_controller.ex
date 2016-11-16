defmodule Classlab.Classroom.MaterialController do
  @moduledoc false
  alias Calendar.DateTime
  alias Classlab.{Material, Membership}
  alias Ecto.{Changeset, Query}
  use Classlab.Web, :controller
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &page_path(&1, :index)

  plug :restrict_roles, [1, 2] when action in
      [:create, :delete, :edit, :lock_all, :new, :toggle_lock, :update, :unlock_all]
  plug :scrub_params, "material" when action in [:create, :update]

  def index(conn, _params) do
    event = current_event(conn)

    unlocked_materials =
      event
      |> assoc(:materials)
      |> Material.unlocked()
      |> Query.order_by([asc: :unlocked_at, asc: :position])
      |> Repo.all()

    locked_materials =
      event
      |> assoc(:materials)
      |> Material.locked()
      |> Query.order_by(asc: :position)
      |> Repo.all()

    current_memberships =
      conn
      |> current_user()
      |> assoc(:memberships)
      |> Membership.for_event(event)
      |> Repo.all()
      |> Repo.preload(:role)

    render(
      conn,
      "index.html",
      current_memberships: current_memberships,
      event: event,
      locked_materials: locked_materials,
      unlocked_materials: unlocked_materials
    )
  end

  def new(conn, _params) do
    event = current_event(conn)
    changeset =
      event
      |> build_assoc(:materials)
      |> Material.changeset()

    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"material" => material_params}) do
    event = current_event(conn)
    changeset =
      event
      |> build_assoc(:materials)
      |> Material.changeset(material_params)

    case Repo.insert(changeset) do
      {:ok, _material} ->
        conn
        |> put_flash(:info, "Material created successfully.")
        |> redirect(to: classroom_material_path(conn, :index, event))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = current_event(conn)
    material =
      event
      |> assoc(:materials)
      |> Repo.get!(id)

    if is_nil(material.unlocked_at) && !has_permission?(current_memberships(conn), [1, 2]) do
      conn
      |> put_flash(:error, "Permission denied!")
      |> redirect(to: "/")
    else
      render(conn, "show.html", material: material, event: event)
    end
  end

  def edit(conn, %{"id" => id}) do
    event = current_event(conn)
    material =
      event
      |> assoc(:materials)
      |> Repo.get!(id)

    changeset = Material.changeset(material)
    render(conn, "edit.html", material: material, changeset: changeset, event: event)
  end

  def update(conn, %{"id" => id, "material" => material_params}) do
    event = current_event(conn)
    material =
      event
      |> assoc(:materials)
      |> Repo.get!(id)

    changeset = Material.changeset(material, material_params)

    case Repo.update(changeset) do
      {:ok, material} ->
        conn
        |> put_flash(:info, "Material updated successfully.")
        |> redirect(to: classroom_material_path(conn, :show, event, material))
      {:error, changeset} ->
        render(conn, "edit.html", material: material, changeset: changeset, event: event)
    end
  end

  def unlock_all(conn, _params) do
    event = current_event(conn)

    event
    |> assoc(:materials)
    |> Material.locked()
    |> Repo.update_all([set: [unlocked_at: DateTime.now_utc()]])

    page_reload_broadcast!([:event, event.id, :material, :unlock])

    conn
    |> put_flash(:info, "Materials successfully unlocked.")
    |> redirect(to: classroom_material_path(conn, :index, event))
  end

  def lock_all(conn, _params) do
    event = current_event(conn)

    event
    |> assoc(:materials)
    |> Material.unlocked()
    |> Repo.update_all([set: [unlocked_at: nil]])

    page_reload_broadcast!([:event, event.id, :material, :lock])

    conn
    |> put_flash(:info, "Materials successfully locked.")
    |> redirect(to: classroom_material_path(conn, :index, event))
  end

  def toggle_lock(conn, %{"id" => material_id}) do
    event = current_event(conn)

    material =
      event
      |> assoc(:materials)
      |> Repo.get!(material_id)

    updates =
      if material.unlocked_at do
        %{unlocked_at: nil}
      else
        %{unlocked_at: DateTime.now_utc()}
      end

    material
    |> Changeset.change(updates)
    |> Repo.update!()

    if material.unlocked_at do
      page_reload_broadcast!([:event, event.id, :material, :lock])
    else
      page_reload_broadcast!([:event, event.id, :material, :unlock])
    end

    flash =
      if material.unlocked_at do
        "Material successfully locked"
      else
        "Material successfully unlocked"
      end

    conn
    |> put_flash(:info, flash)
    |> redirect(to: classroom_material_path(conn, :index, event))
  end

  def delete(conn, %{"id" => id}) do
    event = current_event(conn)
    material =
      event
      |> assoc(:materials)
      |> Repo.get!(id)

    Repo.delete!(material)

    conn
    |> put_flash(:info, "Material deleted successfully.")
    |> redirect(to: classroom_material_path(conn, :index, event))
  end

  # Private methods
end

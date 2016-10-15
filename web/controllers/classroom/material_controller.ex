defmodule Classlab.Classroom.MaterialController do
  alias Classlab.{Material, Event}
  use Classlab.Web, :controller

  plug :scrub_params, "material" when action in [:create, :update]

  def index(conn, _params) do
    event = load_event(conn)
    materials =
      event
      |> assoc(:materials)
      |> Repo.all()

    render(conn, "index.html", materials: materials, event: event)
  end

  def new(conn, _params) do
    event = load_event(conn)
    changeset =
      event
      |> build_assoc(:materials)
      |> Material.changeset()
    render(conn, "new.html", changeset: changeset, event: event)
  end

  def create(conn, %{"material" => material_params}) do
    event = load_event(conn)
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
    event = load_event(conn)
    material =
      event
      |> assoc(:materials)
      |> Repo.get!(id)

    render(conn, "show.html", material: material, event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = load_event(conn)
    material =
      event
      |> assoc(:materials)
      |> Repo.get!(id)

    changeset = Material.changeset(material)
    render(conn, "edit.html", material: material, changeset: changeset, event: event)
  end

  def update(conn, %{"id" => id, "material" => material_params}) do
    event = load_event(conn)
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

  def delete(conn, %{"id" => id}) do
    event = load_event(conn)
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
  defp load_event(conn) do
    Repo.get_by!(Event, slug: conn.params["event_id"])
  end
end

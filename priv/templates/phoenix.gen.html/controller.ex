defmodule <%= module %>Controller do
  alias <%= module %>
  use <%= base %>.Web, :controller

  plug :scrub_params, <%= inspect singular %> when action in [:create, :update]

  def index(conn, _params) do
    <%= plural %> =
      <%= alias %>
      |> Repo.all()

    render(conn, "index.html", <%= plural %>: <%= plural %>)
  end

  def new(conn, _params) do
    changeset = <%= alias %>.changeset(%<%= alias %>{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{<%= inspect singular %> => <%= singular %>_params}) do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, <%= singular %>_params)

    case Repo.insert(changeset) do
      {:ok, _<%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> created successfully.")
        |> redirect(to: <%= singular %>_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    <%= singular %> =
      <%= alias %>
      |> Repo.get!(id)

    render(conn, "show.html", <%= singular %>: <%= singular %>)
  end

  def edit(conn, %{"id" => id}) do
    <%= singular %> =
      <%= alias %>
      |> Repo.get!(id)

    changeset = <%= alias %>.changeset(<%= singular %>)
    render(conn, "edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
  end

  def update(conn, %{"id" => id, <%= inspect singular %> => <%= singular %>_params}) do
    <%= singular %> =
      <%= alias %>
      |> Repo.get!(id)

    changeset = <%= alias %>.changeset(<%= singular %>, <%= singular %>_params)

    case Repo.update(changeset) do
      {:ok, <%= singular %>} ->
        conn
        |> put_flash(:info, "<%= human %> updated successfully.")
        |> redirect(to: <%= singular %>_path(conn, :show, <%= singular %>))
      {:error, changeset} ->
        render(conn, "edit.html", <%= singular %>: <%= singular %>, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    <%= singular %> =
      <%= alias %>
      |> Repo.get!(id)

    Repo.delete!(<%= singular %>)

    conn
    |> put_flash(:info, "<%= human %> deleted successfully.")
    |> redirect(to: <%= singular %>_path(conn, :index))
  end
end

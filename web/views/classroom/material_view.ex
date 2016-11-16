defmodule Classlab.Classroom.MaterialView do
  @moduledoc false
  alias Classlab.Material
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", conn), do: %{
    title: "Materials",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Materials"
    }]
  }
  def page("new.html", conn), do: %{
    title: "New Material",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Materials",
      path: classroom_material_path(conn, :index, conn.assigns.event)
    }, %{
      name: "New material"
    }]
  }
  def page("show.html", conn), do: %{
    title: conn.assigns.material.title,
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Materials",
      path: classroom_material_path(conn, :index, conn.assigns.event)
    }, %{
      name: conn.assigns.material.title
    }]
  }
  def page("edit.html", conn), do: %{
    title: "Edit #{conn.assigns.material.title}",
    breadcrumb: [%{
      name: "My Events",
      path: account_membership_path(conn, :index)
    }, %{
      name: "Current event"
    }, %{
      name: "Materials",
      path: classroom_material_path(conn, :index, conn.assigns.event)
    }, %{
      name: conn.assigns.material.title,
      path: classroom_material_path(conn, :show, conn.assigns.event, conn.assigns.material)
    }, %{
      name: "Edit"
    }]
  }

  # View functions
  def type_collection do
    Material.types()
    |> Enum.map(&({"#{&1.name}", &1.id}))
  end
end

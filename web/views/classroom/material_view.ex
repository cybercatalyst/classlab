defmodule Classlab.Classroom.MaterialView do
  @moduledoc false
  alias Classlab.Material
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Materials"
  }
  def page("new.html", _conn), do: %{
    title: "New Material"
  }
  def page("show.html", conn), do: %{
    title: conn.assigns.material.title
  }
  def page("edit.html", conn), do: %{
    title: "Edit #{conn.assigns.material.title}"
  }

  # View functions
  def type_collection do
    Material.types()
    |> Enum.map(&({"#{&1.name}", &1.id}))
  end
end

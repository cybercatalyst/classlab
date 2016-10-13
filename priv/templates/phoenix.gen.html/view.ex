defmodule <%= module %>View do
  use <%= base %>.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "<%= template_plural %>"
  }
  def page("show.html", conn), do: %{
    title: "<%= template_singular %> #{conn.assigns.<%= singular %>.<%= attrs |> Enum.at(0) |> elem(0) %>}"
  }
  def page("new.html", _conn), do: %{
    title: "New <%= template_singular %>"
  }
  def page("edit.html", _conn), do: %{
    title: "Edit <%= template_singular %>"
  }

  # View functions
end

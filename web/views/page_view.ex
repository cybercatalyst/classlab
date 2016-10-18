defmodule Classlab.PageView do
  use Classlab.Web, :view

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Homepage"
  }
end

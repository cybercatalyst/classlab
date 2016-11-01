defmodule Classlab.Classroom.EventEmailTemplateView do
  @moduledoc false
  alias Classlab.Event
  use Classlab.Web, :view

  # Page Configuration
  def page("edit.html", _conn), do: %{
    title: "E-Mail templates",
    breadcrumb: [%{
      name: "E-Mail templates"
    }]
  }

  # View functions

end

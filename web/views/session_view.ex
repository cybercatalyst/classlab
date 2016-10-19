defmodule Classlab.SessionView do
  @moduledoc false
  use Classlab.Web, :view

  # Page Configuration
  def page("new.html", _conn), do: %{
    title: "Login"
  }
end

defmodule Classlab.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Classlab.Web, :controller
      use Classlab.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema
      use Calecto.Schema, usec: true

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      alias Classlab.{Repo, Mailer}
      use Phoenix.Controller

      import Ecto
      import Ecto.Query
      import Classlab.AssignUserPlug, only: [current_user: 1]
      import Classlab.Gettext
      import Classlab.Router.Helpers
      import Classlab.Turbolinks.ControllerExtensions
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"
      use Phoenix.HTML

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
      import Classlab.AssignUserPlug, only: [current_user: 1]
      import Classlab.CalendarHelpers
      import Classlab.ErrorHelpers
      import Classlab.Gettext
      import Classlab.InputHelpers
      import Classlab.PageReloadHelpers
      import Classlab.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      alias Classlab.Repo
      use Phoenix.Channel

      import Ecto
      import Ecto.Query
      import Classlab.Gettext
    end
  end

  def mailer do
    quote do
      import Bamboo.Email
      import Classlab.Router.Helpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

defmodule Classlab.EventCopy do
  @moduledoc """
  """
  use Classlab.Web, :model

  # Fields
  schema "" do
    field :name, :string
    field :copy_tasks, :boolean, default: true
    field :copy_materials, :boolean, default: true
    field :copy_attendees, :boolean, default: false
  end

  # Changesets & Validations
  @fields [:name]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:email])
  end

  # Model Functions
end

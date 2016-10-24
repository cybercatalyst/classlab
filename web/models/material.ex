defmodule Classlab.Material do
  @moduledoc """
  Connects a material with an event. All event materials are
  visible to the attendees of an event. Similar to task.
  """
  use Classlab.Web, :model

  # Fields
  schema "materials" do
    field :type, :integer
    field :description, :string
    field :position, :integer
    field :title, :string
    field :unlocked_at, Calecto.DateTimeUTC
    field :url, :string
    timestamps

    belongs_to :event, Classlab.Event
  end

  # Changesets & Validations
  @fields [:description, :type, :position, :title, :url]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> unique_constraint(:position)
  end

  # Methods
  def types do
    [
      %{id: 1, name: "Slidedeck"},
      %{id: 2, name: "Video"}
    ]
  end
end

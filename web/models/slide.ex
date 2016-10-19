defmodule Classlab.Slide do
  @moduledoc """
  Connects a slide with an event. All event slides are
  visible to the attendees of an event. Similar to task.
  """
  use Classlab.Web, :model

  # Fields
  schema "slides" do
    field :description, :string
    field :position, :integer
    field :title, :string
    field :url, :string
    timestamps

    belongs_to :event, Classlab.Event
  end

  # Changesets & Validations
  @fields [:title, :position, :url, :description]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end

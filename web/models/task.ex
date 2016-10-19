defmodule Classlab.Task do
  @moduledoc """
  Connects a task with an event. All event tasks are
  visible to the attendees of an event.
  """
  use Classlab.Web, :model

  # Fields
  schema "tasks" do
    field :body, :string
    field :bonus, :string
    field :external_app_url, :string
    field :hint, :string
    field :position, :integer
    field :title, :string
    timestamps

    belongs_to :event, Classlab.Event
  end

  # Changesets & Validations
  @fields [:body, :bonus, :external_app_url, :hint, :position, :title]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:body, :position, :title])
  end
end

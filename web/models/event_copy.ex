defmodule Classlab.EventCopy do
  @moduledoc """
  A struct for copying an event.
  Let's you select the associations you want to copy with the event.
  """
  alias Classlab.Event
  use Classlab.Web, :model

  # Fields
  schema "" do
    field :name, :string
    field :copy_tasks, :boolean, default: true
    field :copy_materials, :boolean, default: true
  end

  # Changesets & Validations
  @fields ~w(name copy_tasks copy_materials)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(name copy_tasks copy_materials)a)
  end

  # Model Functions
  def copy_event(%__MODULE__{} = event_copy, %Event{} = event) do
    event
    |> Map.delete(:id)
    |> Map.put(:name, event_copy.name)
    |> copy_event_attr(:tasks, event_copy.copy_tasks)
    |> copy_event_attr(:materials, event_copy.copy_materials)
  end

  defp copy_event_attr(%Event{} = event, _attr, true), do: event
  defp copy_event_attr(%Event{} = event, attr, false), do: Map.delete(event, attr)
end

defmodule Classlab.Material do
  use Classlab.Web, :model

  # Fields
  schema "materials" do
    field :visible, :boolean, default: false
    field :name, :string
    field :type, :integer
    timestamps()

    belongs_to :event, Classlab.Event
    embeds_one :contents, Classlab.MaterialTask
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(visible name type)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> cast_embed(:contents)
    |> validate_required(~w(visible name type)a)
  end

  # Model Functions
end

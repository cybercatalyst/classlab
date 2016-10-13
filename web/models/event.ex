defmodule Classlab.Event do
  use Classlab.Web, :model

  schema "events" do
    field :public, :boolean, default: false
    field :slug, :string
    field :name, :string
    field :description, :string
    field :starts_at, Ecto.DateTime
    field :ends_at, Ecto.DateTime
    field :timezone, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:public, :slug, :name, :description, :starts_at, :ends_at, :timezone])
    |> validate_required([:public, :slug, :name, :description, :starts_at, :ends_at, :timezone])
  end
end

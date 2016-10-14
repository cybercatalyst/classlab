defmodule Classlab.MaterialTask do
  use Classlab.Web, :model

  embedded_schema do
    field :name, :string
  end

  @fields ~w(name)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(name)a)
  end
end
defmodule Classlab.Location do
  @moduledoc """
  A location always belongts to one event. Maybe later we
  could reuse events.
  """
  use Classlab.Web, :model

  # Fields
  schema "locations" do
    field :name, :string
    field :address_line_1, :string
    field :address_line_2, :string
    field :zipcode, :string
    field :city, :string
    field :country, :string
    field :external_url, :string
    timestamps()

    has_one :event, Classlab.Event
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(name address_line_1 address_line_2 zipcode city country external_url)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(name address_line_1 zipcode city country)a)
  end

  # Model Functions
end

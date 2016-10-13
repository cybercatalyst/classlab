defmodule Classlab.Session do
  @moduledoc """
  The session model encapsulates session handling. It can take an email address
  and an optional token.
  """
  use Classlab.Web, :model

  # Fields
  schema "" do
    field :email, :string
  end

  # Changesets & Validations
  @fields [:email]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:email])
  end
end

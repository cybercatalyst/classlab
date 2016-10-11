defmodule Classlab.User do
  use Classlab.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :access_token, :string
    field :access_token_expired_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @fields [:first_name, :last_name, :email, :access_token, :access_token_expired_at]
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required([:first_name, :last_name, :email, :access_token, :access_token_expired_at])
  end
end

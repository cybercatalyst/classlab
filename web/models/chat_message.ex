defmodule Classlab.ChatMessage do
  use Classlab.Web, :model

  # Fields
  schema "chat_messages" do
    field :body, :string
    timestamps()

    belongs_to :event, Classlab.Event
    belongs_to :user, Classlab.User
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(body)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(body)a)
  end

  # Model Functions
end

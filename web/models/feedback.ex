defmodule Classlab.Feedback do
  use Classlab.Web, :model

  # Fields
  schema "feedbacks" do
    field :content_rating, :integer, default: 1
    field :content_comment, :string
    field :trainer_rating, :integer, default: 1
    field :trainer_comment, :string
    field :location_rating, :integer, default: 1
    field :location_comment, :string
    field :testimonial, :string
    timestamps()

    belongs_to :event, Classlab.Event
    belongs_to :user, Classlab.User
  end

  # Composable Queries

  # Changesets & Validations
  @fields ~w(event_id content_rating content_comment trainer_rating trainer_comment location_rating location_comment testimonial)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(event_id content_rating trainer_rating location_rating)a)
    |> validate_inclusion(:content_rating, 1..5)
    |> validate_inclusion(:trainer_rating, 1..5)
    |> validate_inclusion(:location_rating, 1..5)
  end

  # Model Functions
end

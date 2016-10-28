defmodule Classlab.Feedback do
  @moduledoc """
  Feedback model. Belongs to an event and an user.
  """
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
  def averages(query) do
    from feedback in query, select: %{
      trainer_rating: avg(feedback.trainer_rating),
      content_rating: avg(feedback.content_rating),
      location_rating: avg(feedback.location_rating)
    }
  end

  # Changesets & Validations
  @fields ~w(content_rating content_comment trainer_rating trainer_comment
             location_rating location_comment testimonial)
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> validate_required(~w(content_rating trainer_rating location_rating)a)
    |> validate_inclusion(:content_rating, 1..5)
    |> validate_inclusion(:trainer_rating, 1..5)
    |> validate_inclusion(:location_rating, 1..5)
  end

  # Model Functions
end

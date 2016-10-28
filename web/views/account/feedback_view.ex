defmodule Classlab.Account.FeedbackView do
  @moduledoc false
  use Classlab.Web, :view
  import Classlab.StarHelpers

  # Page Configuration
  def page("index.html", _conn), do: %{
    title: "Feedbacks"
  }

  # View functions
end

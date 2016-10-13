defmodule Classlab.MailerCase do
  @moduledoc """
  This module defines the test case to be used by
  mailers.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use Bamboo.Test

      alias Classlab.Repo
      alias Classlab.Endpoint
      alias Classlab.Factory

      import Classlab.Router.Helpers
    end
  end
end

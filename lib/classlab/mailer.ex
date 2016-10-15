defmodule Classlab.Mailer do
  @moduledoc """
  Base mailer. Adds Bamboo mailer to our Classlab app for sending mails.
  """
  use Bamboo.Mailer, otp_app: :classlab
end

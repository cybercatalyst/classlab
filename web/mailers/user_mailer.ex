defmodule Classlab.UserMailer do
  @moduledoc """
  User mailer. Builds up emails connected with user model.
  """
  alias Classlab.{Endpoint, Mailer, User}
  use Classlab.Web, :mailer

  def token_email(%User{email: email, access_token: access_token}) do
    login_url = session_url(Endpoint, :show, access_token)

    new_email
    |> to(email)
    |> from(Application.get_env(:classlab, Mailer, :from))
    |> subject("Your access token")
    |> html_body("Token: <a href=\"#{login_url}\" target=\"_blank\">#{login_url}</a>")
    |> text_body("Token: #{login_url}")
  end
end

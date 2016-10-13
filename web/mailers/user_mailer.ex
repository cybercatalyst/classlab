defmodule Classlab.UserMailer do
  alias Classlab.{Endpoint, User}
  use Classlab.Web, :mailer

  def token_email(%User{email: email, access_token: access_token}) do
    new_email
    |> to(email)
    |> from("me@example.com")
    |> subject("Your access token")
    |> text_body("Token: #{session_url(Endpoint, :show, access_token)}")
  end
end
defmodule Classlab.UserMailerTest do
  alias Classlab.UserMailer
  use Classlab.MailerCase

  test "#token_email" do
    user = Factory.build(:user)
    email = UserMailer.token_email(user)

    assert email.to == user.email
    assert email.text_body =~ session_path(Endpoint, :show, user.access_token)
    assert email.html_body =~ session_path(Endpoint, :show, user.access_token)
  end
end

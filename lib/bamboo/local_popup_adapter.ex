defmodule Bamboo.LocalPopupAdapter do
  @moduledoc """
  Stores emails locally. Can be queried to see sent emails.
  Opens the email in a new tab.

  ## Example config

      # In config/config.exs, or config/dev.exs, etc.
      config :my_app, MyApp.Mailer,
        adapter: Bamboo.LocalPopupAdapter

      # Define a Mailer. Maybe in lib/my_app/mailer.ex
      defmodule MyApp.Mailer do
        use Bamboo.Mailer, otp_app: :my_app
      end
  """
  alias Bamboo.SentEmail

  @behaviour Bamboo.Adapter

  @doc "Adds email to Bamboo.SentEmail and open the email locally"
  def deliver(email, config) do
    email = SentEmail.push(email)
    email_id = email.private.local_adapter_id
    open_browser("#{config.at}/#{email_id}")
  end

  def handle_config(config), do: config

  defp open_browser(url) do
    System.cmd("open", [url])
  end
end

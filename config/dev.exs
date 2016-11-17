use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :classlab, Classlab.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :classlab, Classlab.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# JWT secret for signing session token
config :classlab, :jwt_secret, "9a42772e-91f4-11e6-8ecd-8f42e8056b9f"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :classlab, Classlab.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "classlab_dev",
  hostname: "localhost",
  pool_size: 10

config :classlab, Classlab.Mailer,
  adapter: Bamboo.LocalPopupAdapter,
  at: "http://localhost:4000/sent_emails",
  from_email: "mailer@example.com",
  from_name: "Classlab dev"

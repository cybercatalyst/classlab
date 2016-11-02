use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :classlab, Classlab.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "demo.classlab.org", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  check_origin: false,
  server: true

# JWT secret for signing session token
config :classlab, :jwt_secret, "23324324-91f4-123456-8ecd-74332wg"

# Do not print debug messages in demo
config :logger, level: :info

# Configure your database
config :classlab, Classlab.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "demo",
  password: "demo123",
  database: "classlab_demo",
  hostname: "127.0.0.1",
  pool_size: 10

config :classlab, Classlab.Mailer,
  adapter: Bamboo.LocalAdapter

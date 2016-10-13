use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :classlab, Classlab.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :classlab, Classlab.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || System.get_env("LOGNAME"),
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "",
  database: "classlab_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :classlab, Classlab.Mailer,
  adapter: Bamboo.TestAdapter

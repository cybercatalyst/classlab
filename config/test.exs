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
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("DATABASE_MYSQL_USERNAME") || "root",
  password: System.get_env("DATABASE_MYSQL_PASSWORD") || "",
  database: "classlab_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :classlab, Classlab.Mailer,
  adapter: Bamboo.TestAdapter,
  from_email: "mailer@example.com",
  from_name:  "Classlab test"

  # JWT secret for signing session token
config :classlab, :jwt_secret, "a401993e-91f4-11e6-a7af-030741a2ba6a"

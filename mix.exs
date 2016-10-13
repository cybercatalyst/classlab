defmodule Classlab.Mixfile do
  use Mix.Project

  def project do
    [app: :classlab,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Classlab, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Please sort by name
  defp deps do
    [
      {:bamboo, "~> 0.7"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.4.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.3.5", only: :dev},
      {:gettext, "~> 0.11"},
      {:inch_ex, "~> 0.5", only: :docs},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix, "~> 1.2.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "setup": ["ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "credo": ["credo --strict"],
      "s": ["phoenix.server"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

defmodule Classlab.Mixfile do
  use Mix.Project

  def project do
    [app: :classlab,
     version: "0.0.1",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_path: build_path_prefix <> "/_build",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test],
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Classlab, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :bamboo, :quantum]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Please sort by name
  defp deps do
    [
      {:bamboo, "~> 0.7"},
      {:calecto, "~> 0.16.0"},
      {:calendar_translations, "~> 0.0.3"},
      {:calendar, "~> 0.16.0"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.5.1", only: [:dev, :test]},
      {:dialyxir, "~> 0.3.5", only: :dev},
      {:earmark, "~> 1.0.2"},
      {:excoveralls, "~> 0.5", only: :test},
      {:ex_doc, "~> 0.13", only: :dev},
      {:ex_machina, "~> 1.0", only: :test},
      {:gettext, "~> 0.12.1"},
      {:inch_ex, "~> 0.5", only: :docs},
      {:joken, "~> 1.3.1"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix, "~> 1.2.0"},
      {:postgrex, ">= 0.0.0"},
      {:quantum, ">= 1.8.0"}
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

  @doc """
  You can't use symlinks to build paths. So we have to set this
  manually.
  """
  defp ci_build_path_prefix do
    if System.get_env("SEMAPHORE_CACHE_DIR") do
      System.get_env("SEMAPHORE_CACHE_DIR")
    else
      "."
    end
  end
end

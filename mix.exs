defmodule Howtosay.Mixfile do
  use Mix.Project

  def project do
    [app: :howtosay,
     version: "0.0.1",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Howtosay, []},
     applications: [:phoenix, :cowboy, :logger, :gettext, :comeonin, :phoenix_html,
                    :phoenix_ecto, :postgrex, :ja_serializer, :faker, :phoenix_pubsub]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:ja_serializer, "0.10.0"},
      {:cors_plug, "~> 1.1"},
      {:guardian, "~> 0.12.0"},
      {:guardian_db, "0.7.0"},
      {:comeonin, "~> 2.5"},
      {:faker, "~> 0.6", only: [:test, :dev]},
      {:phoenix_html, "~> 2.6.0"},
      {:mailgun, "~> 0.1.2"},
      {:scrivener_ecto, "~> 1.0"},
      {:scrivener, "~> 2.0", override: true},
      {:credo, "~> 0.4.1", only: [:dev, :test]},
      {:dialyxir, "~> 0.3.3", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end

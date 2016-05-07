defmodule Howtosay.Mixfile do
  use Mix.Project

  def project do
    [app: :howtosay,
     version: "0.0.1",
     elixir: "~> 1.0",
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
                    :phoenix_ecto, :postgrex, :ja_serializer, :faker]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.1.4"},
      {:phoenix_ecto, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:ja_serializer, "0.8.1"},
      {:cors_plug, "~> 0.1.4"},
      {:guardian, "~> 0.9.0"},
      {:guardian_db, "0.4.0"},
      {:comeonin, "~> 2.0.0"},
      {:faker, "~> 0.5", only: [:test, :dev]},
      {:phoenix_html, "~> 2.5.0"},
      {:mailgun, "~> 0.1.2"},
      {:scrivener, "~> 1.1.2"}
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
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end

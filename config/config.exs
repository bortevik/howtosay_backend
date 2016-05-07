# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :howtosay, Howtosay.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "aTF6qzV/5ZwO8TyfYgMb3tK1fU4IVwAspt5AvsS+X/G8+ATEMcnYubrAoKrhWUq9",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Howtosay.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :format_encoders, "json-api": Poison
config :plug, :mimes, %{"application/vnd.api+json" => ["json-api"]}

config :guardian, Guardian,
  issuer: "Howtosay.#{Mix.env}",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "uzZKL9DaGUb0foWi6z7RRAjHbE1UltblNB/qM2SqM249mM0cv6lLThT1hKHCjjP4",
  serializer: Howtosay.GuardianSerializer,
  hooks: GuardianDb

config :guardian_db, GuardianDb, repo: Howtosay.Repo

config :howtosay, client_host: "http://localhost:4201"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "config.secret.exs"

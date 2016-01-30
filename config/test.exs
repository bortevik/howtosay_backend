use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :howtosay, Howtosay.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :debug # :warn :info :error

# Configure your database
config :howtosay, Howtosay.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "howtosay_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, :pbkdf2_rounds, 1

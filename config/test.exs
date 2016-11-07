use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cuenta, Cuenta.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cuenta, Cuenta.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: (System.get_env("CUENTA_DATABASE_USER") || "root"),
  password: (System.get_env("CUENTA_DATABASE_PASSWORD") || ""),
  database: "cuenta_test",
  hostname: (System.get_env("CUENTA_DATABASE_HOST") || "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

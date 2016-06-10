use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :cuenta, Cuenta.Endpoint,
  secret_key_base: "ztdDE2vIJXnwdldwiKB3iKqEoVrehArsmuQPefVCk08X0qublS0tTzcBfONto+Qq"

# Configure your database
config :cuenta, Cuenta.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "cuenta_prod",
  pool_size: 20

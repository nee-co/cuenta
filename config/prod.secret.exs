use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :cuenta, Cuenta.Endpoint,
  secret_key_base: "IdH0eUmgr3/E0HEyOfNGSNltZgCMpcazXUr5o8yFTUSWX3sIfJ852tSTh2ZHKTVR" # TODO: これも環境変数にする

# Configure your database
config :cuenta, Cuenta.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("CUENTA_DATABASE_USER"),
  password: System.get_env("CUENTA_DATABASE_PASSWORD"),
  database: "cuenta_prod",
  hostname: System.get_env("CUENTA_DATABASE_HOST"),
  pool_size: 20

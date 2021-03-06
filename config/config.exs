# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cuenta,
  ecto_repos: [Cuenta.Repo],
  imagen_url: System.get_env("IMAGEN_URL"),
  kong_url: System.get_env("KONG_URL"),
  olvido_url: System.get_env("OLVIDO_URL"),
  static_image_url: System.get_env("STATIC_IMAGE_URL") || "static url has not been set"

# Configures the endpoint
config :cuenta, Cuenta.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Bkxvd/l3zAnR1lz8VV8jv/vQ3j+Nr4wCGmvsKd0sC/j+gzA/rKKLDQ9KLWUNYcA5",
  render_errors: [view: Cuenta.ErrorView, accepts: ~w(json)],
  pubsub: [name: Cuenta.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

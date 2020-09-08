# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :srb_home_center_ui, SrbHomeCenterUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9+Fm1IxJ40NTDbUphgn6uSW4Nx5f0hxhZOUPH9royY7D0/+5qAXknPjtGZwIuYx8",
  render_errors: [view: SrbHomeCenterUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SrbHomeCenterUi.PubSub,
  live_view: [signing_salt: "0y2IkCHB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

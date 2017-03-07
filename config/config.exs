# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :choobio,
  ecto_repos: [Choobio.Repo]

# Configures the endpoint
config :choobio, Choobio.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GatByZkLPg8JPSVek8DARGKsn13rdxj/e6pnyZgQuQNvStQ2oztx/WeWtuV+YZxS",
  render_errors: [view: Choobio.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Choobio.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

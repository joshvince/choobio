use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :choobio, Choobio.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Use the Mock for tests when calling TFL's API.
config :choobio, :tfl_api, Choobio.Tfl.Mock

# Configure your database
config :choobio, Choobio.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "choobio_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

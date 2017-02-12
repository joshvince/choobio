use Mix.Config

config :commuter, :tfl_api, Commuter.Tfl
config :commuter,
  server: true,
  port: String.to_integer(System.get_env("PORT") || "4001")

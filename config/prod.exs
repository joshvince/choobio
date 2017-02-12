use Mix.Config

config :commuter, :tfl_api, Commuter.Tfl
config :commuter,
  server: true,
  http: [port: 4000]

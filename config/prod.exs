use Mix.Config

config :commuter, :tfl_api, Commuter.Tfl
config :commuter,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "choob-service.herokuapp.com", port: 443]

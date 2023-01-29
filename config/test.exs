import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ogluna, OglunaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SdivUIhgc6HzsuNEO/uBCRB4OT+IvwYxHFG7iYdb3CbcgxU/uTXBgMzyPo2X0THj",
  server: false

# In test we don't send emails.
config :ogluna, Ogluna.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

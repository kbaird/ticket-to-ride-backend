use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ticket_to_ride, TicketToRide.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Set a higher stacktrace during test
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :ticket_to_ride, TicketToRide.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: "ticket_to_ride_test",
  pool: Ecto.Adapters.SQL.Sandbox

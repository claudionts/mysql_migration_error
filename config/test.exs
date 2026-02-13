import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
import Config

config :mysql_migration_error_phx, MysqlMigrationErrorPhx.Repo,
  username: System.get_env("DB_USER", "app"),
  password: System.get_env("DB_PASSWORD", "apppass"),
  hostname: System.get_env("DB_HOST", "db"),
  port: String.to_integer(System.get_env("DB_PORT", "3306")),
  database: System.get_env("DB_NAME", "mysql_migration_error_test"),
  pool: Ecto.Adapters.SQL.Sandbox


# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mysql_migration_error_phx, MysqlMigrationErrorPhxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "qMbdJ6EoFRPmHgDtGyISNylFGELAc1Un1p8CBPCSGr0Fs10xZ6qLeajjo5EGwFaE",
  server: false

# In test we don't send emails
config :mysql_migration_error_phx, MysqlMigrationErrorPhx.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true

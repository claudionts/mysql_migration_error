import Config

config :mysql_migration_error,
  ecto_repos: [MysqlMigrationError.Repo]

config :mysql_migration_error, MysqlMigrationError.Repo,
  username: "root",
  password: "rootpassword",
  hostname: "localhost",
  port: 3306,
  database: "mysql_migration_error_dev",
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

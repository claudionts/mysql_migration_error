defmodule MysqlMigrationErrorPhx.Repo do
  use Ecto.Repo,
    otp_app: :mysql_migration_error_phx,
    adapter: Ecto.Adapters.Postgres
end

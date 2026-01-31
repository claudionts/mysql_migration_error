defmodule MysqlMigrationError.Repo do
  use Ecto.Repo,
    otp_app: :mysql_migration_error,
    adapter: Ecto.Adapters.MyXQL
end

defmodule MysqlMigrationErrorPhx.Repo.Migrations.CreateLinksBadFk do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :text

      # This replicates the Elixir Forum issue:
      # Using type: :id generates INTEGER instead of BIGINT
      # In MySQL/MariaDB this causes error 1005, let's see if PostgreSQL handles it
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:links, [:user_id])
  end
end

defmodule MysqlMigrationErrorPhx.Repo.Migrations.CreateLinksFixedFk do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :text

      # SOLUTION 1: Explicitly specify :bigint instead of relying on type: :id
      add :user_id, references(:users, type: :bigint, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:links, [:user_id])
  end
end

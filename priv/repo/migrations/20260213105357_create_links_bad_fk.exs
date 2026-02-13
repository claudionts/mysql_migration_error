defmodule MysqlMigrationErrorPhx.Repo.Migrations.CreateLinksBadFk do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :text

      # Make FK column match users.id (bigint unsigned)
      add :user_id, references(:users, type: :"bigint unsigned", on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:links, [:user_id])
  end
end

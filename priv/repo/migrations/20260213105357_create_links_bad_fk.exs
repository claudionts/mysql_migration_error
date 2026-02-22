defmodule MysqlMigrationErrorPhx.Repo.Migrations.CreateLinksBadFk do
  use Ecto.Migration

  def change do
    # ❌ THIS MIGRATION CAUSES ERROR 1005
    # Even though type: :id is specified, it generates `user_id integer` 
    # but users.id is `bigint unsigned` - mismatch causes foreign key error!
    
    # To fix without running this, see the CreateLinksFixedFk migration instead
    
    create table(:links) do
      add :url, :text

      # Problem: type: :id generates :integer instead of :bigint unsigned
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:links, [:user_id])
  end
end

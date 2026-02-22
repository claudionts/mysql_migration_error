defmodule MysqlMigrationErrorPhx.Repo.Migrations.CreateLinksWithIntegerFk do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text
      
      # EXPLICIT INTEGER - This causes Error 1005!
      # users.id is :bigint unsigned, but we're creating user_id as :integer
      add :user_id, references(:users, type: :integer, on_delete: :delete_all)
      
      timestamps(type: :utc_datetime)
    end
    
    create index(:comments, [:user_id])
  end
end

defmodule MysqlMigrationError.Repo.Migrations.CreatePostsWithFkError do
  use Ecto.Migration

  def change do
    # SCENARIO 1: Trying to create foreign key to a table that doesn't exist yet
    # This will cause error 1005 (ER_CANT_CREATE_TABLE)
    create table(:posts) do
      add :title, :string
      add :body, :text
      # Referencing 'users' which hasn't been created yet
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:posts, [:user_id])
  end
end

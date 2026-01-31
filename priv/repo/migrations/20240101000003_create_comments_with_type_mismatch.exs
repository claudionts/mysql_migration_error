defmodule MysqlMigrationError.Repo.Migrations.CreateCommentsWithTypeMismatch do
  use Ecto.Migration

  def change do
    # SCENARIO 2: Incompatible type between FK and PK
    # The users table uses bigint (Ecto's default) but we'll use :integer here
    create table(:comments) do
      add :content, :text
      # This will cause an error because users.id is bigint but we're using integer
      add :user_id, :integer, null: false

      timestamps()
    end

    # Trying to add the constraint manually will cause an incompatible type error
    execute """
    ALTER TABLE comments
    ADD CONSTRAINT fk_comments_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
    """, "ALTER TABLE comments DROP FOREIGN KEY fk_comments_user_id"
  end
end

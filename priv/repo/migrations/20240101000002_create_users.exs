defmodule MysqlMigrationError.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    # This table should have been created BEFORE posts
    create table(:users) do
      add :name, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end

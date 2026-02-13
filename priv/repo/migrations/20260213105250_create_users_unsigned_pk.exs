defmodule MysqlMigrationErrorPhx.Repo.Migrations.CreateUsersUnsignedPk do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :"bigint unsigned", primary_key: true
      add :email, :string, null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end

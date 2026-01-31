# Reproducing Error 1005 (ER_CANT_CREATE_TABLE) - MySQL/MariaDB with Ecto

This project reproduces the common `ERROR 1005 (HY000): Can't create table` error that occurs when running Ecto migrations with MySQL/MariaDB using MyXQL.

## Reference

Based on the forum topic: https://elixirforum.com/t/migrations-with-mysql-myxql-error-1005-er-cant-create-table-cant-create-table/72097

## The Problem

Error 1005 typically occurs in three main scenarios:

### Scenario 1: Incorrect Table Creation Order
When we try to create a foreign key to a table that doesn't exist yet. In our example:
- Migration `20240101000001_create_posts_with_fk_error.exs` tries to create the `posts` table with a FK to `users`
- But the `users` table is only created in migration `20240101000002_create_users.exs`

### Scenario 2: Incompatible Types
When the data types of the foreign key and primary key are not compatible:
- The `users` table uses `bigint` (Ecto's default for IDs)
- Migration `20240101000003_create_comments_with_type_mismatch.exs` tries to create a FK using `:integer`

### Scenario 3: Incompatible Charset/Collation
When tables have different charset or collation (not reproduced in this example, but it's another common cause).

## Prerequisites

- Elixir 1.14 or higher
- Docker and Docker Compose
- Mix installed

## How to Reproduce the Error

### 1. Start MariaDB

```bash
docker-compose up -d
```

Wait a few seconds for MariaDB to fully initialize.

### 2. Install Dependencies

```bash
mix deps.get
```

### 3. Try Running the Migrations (will fail!)

```bash
mix ecto.create
mix ecto.migrate
```

You will see an error similar to:

```
** (MyXQL.Error) (1005) (ER_CANT_CREATE_TABLE) Can't create table `mysql_migration_error_dev`.`posts` (errno: 150 "Foreign key constraint is incorrectly formed")
```

### 4. View Error Details in MariaDB

To see more details about the error:

```bash
docker exec -it mysql_migration_error_db mysql -uroot -prootpassword -e "SHOW ENGINE INNODB STATUS\G" | grep -A 20 "LATEST FOREIGN KEY ERROR"
```

## How to Fix

### Solution for Scenario 1: Correct Migration Order

Rename the migrations to ensure the correct order:

```bash
# The users table must be created BEFORE posts
mv priv/repo/migrations/20240101000002_create_users.exs \
   priv/repo/migrations/20240101000000_create_users.exs

mv priv/repo/migrations/20240101000001_create_posts_with_fk_error.exs \
   priv/repo/migrations/20240101000001_create_posts.exs
```

### Solution for Scenario 2: Compatible Types

In the comments migration, use the same type as the referenced table:

```elixir
# Instead of:
add :user_id, :integer, null: false

# Use:
add :user_id, references(:users, on_delete: :delete_all), null: false
# Or explicitly:
add :user_id, :bigint, null: false
```

### Apply the Fixes

1. Reset the database:
```bash
mix ecto.drop
mix ecto.create
```

2. Apply the fixes to the migrations as described above

3. Run again:
```bash
mix ecto.migrate
```

## Project Structure

```
mysql_migration_error/
├── config/
│   └── config.exs              # Repo configuration
├── lib/
│   └── mysql_migration_error/
│       ├── application.ex      # Application supervisor
│       └── repo.ex             # Ecto Repo
├── priv/
│   └── repo/
│       └── migrations/         # Migrations with intentional errors
├── docker-compose.yml          # MariaDB container
├── mix.exs                     # Project dependencies
└── README.md                   # This file
```

## Dependencies

- `ecto_sql` ~> 3.10 - Ecto SQL adapter
- `myxql` ~> 0.6.3 - MySQL driver for Elixir

## Cleanup

To remove the container and volumes:

```bash
docker-compose down -v
```

## Debugging Tips

1. **Check InnoDB status:**
   ```bash
   docker exec -it mysql_migration_error_db mysql -uroot -prootpassword \
     -e "SHOW ENGINE INNODB STATUS\G"
   ```

2. **View created tables:**
   ```bash
   docker exec -it mysql_migration_error_db mysql -uroot -prootpassword \
     mysql_migration_error_dev -e "SHOW TABLES;"
   ```

3. **View table structure:**
   ```bash
   docker exec -it mysql_migration_error_db mysql -uroot -prootpassword \
     mysql_migration_error_dev -e "DESCRIBE users;"
   ```

4. **View foreign keys:**
   ```bash
   docker exec -it mysql_migration_error_db mysql -uroot -prootpassword \
     mysql_migration_error_dev -e "SELECT * FROM information_schema.TABLE_CONSTRAINTS \
     WHERE CONSTRAINT_TYPE = 'FOREIGN KEY';"
   ```

## References

- [Ecto SQL Documentation](https://hexdocs.pm/ecto_sql/)
- [MyXQL Documentation](https://hexdocs.pm/myxql/)
- [MySQL Error 1005](https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html#error_er_cant_create_table)
- [MariaDB Foreign Keys](https://mariadb.com/kb/en/foreign-keys/)

defmodule Howtosay.Repo.Migrations.CreateUser do
  use Ecto.Migration
  @disable_ddl_transaction true

  def up do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :hashed_password, :text
      add :confirmation_token, :text
      add :confirmed_at, :datetime
      add :password_reset_token, :text

      timestamps()
    end

    create unique_index(:users, [:email], concurrently: true)
    create index(:users, [:password_reset_token], concurrently: true)
    create index(:users, [:confirmation_token], concurrently: true)
  end

  def down do
    drop table(:users)
  end
end

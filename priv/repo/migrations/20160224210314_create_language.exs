defmodule Howtosay.Repo.Migrations.CreateLanguage do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:languages) do
      add :name, :string, null: false
      add :code, :string, null: false

      timestamps
    end

    create unique_index(:languages, [:name], concurrently: true)
    create unique_index(:languages, [:code], concurrently: true)
  end
end

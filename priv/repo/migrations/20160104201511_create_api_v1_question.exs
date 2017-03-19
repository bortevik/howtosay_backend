defmodule Howtosay.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :text, :text

      timestamps()
    end

  end
end

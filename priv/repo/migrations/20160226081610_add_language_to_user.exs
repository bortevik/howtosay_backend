defmodule Howtosay.Repo.Migrations.AddLanguageToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :language_id, references(:languages)
    end

    create index(:users, [:language_id])
  end
end

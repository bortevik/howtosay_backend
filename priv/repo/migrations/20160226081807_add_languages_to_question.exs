defmodule Howtosay.Repo.Migrations.AddLanguagesToQuestion do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :language_from_id, references(:languages, on_delete: :delete_all)
      add :language_to_id, references(:languages, on_delete: :delete_all)
    end

    create index(:questions, [:language_from_id])
    create index(:questions, [:language_to_id])
    create index(:questions, [:language_from_id, :language_to_id])
  end
end

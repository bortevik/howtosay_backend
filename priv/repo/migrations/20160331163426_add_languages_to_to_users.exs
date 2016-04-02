defmodule Howtosay.Repo.Migrations.AddLanguageToIdsToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :language_to_ids, {:array, :integer}
    end
  end

  def down do
    alter table(:users) do
      remove :language_to_ids
    end
  end
end

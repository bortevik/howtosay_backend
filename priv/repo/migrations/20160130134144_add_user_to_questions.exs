defmodule Howtosay.Repo.Migrations.AddUserToQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:questions, [:user_id])
  end
end

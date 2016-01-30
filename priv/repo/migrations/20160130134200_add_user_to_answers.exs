defmodule Howtosay.Repo.Migrations.AddUserToAnswers do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:answers, [:user_id])
  end
end

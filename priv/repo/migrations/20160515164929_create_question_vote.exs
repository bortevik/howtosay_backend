defmodule Howtosay.Repo.Migrations.CreateQuestionVote do
  use Ecto.Migration

  def change do
    create table(:question_votes) do
      add :vote, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :question_id, references(:questions, on_delete: :delete_all)

      timestamps
    end

    create index(:question_votes, [:user_id])
    create index(:question_votes, [:question_id])
    create unique_index(:question_votes, [:user_id, :question_id])
  end
end

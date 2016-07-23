defmodule Howtosay.Repo.Migrations.CreateAnswerVote do
  use Ecto.Migration

  def change do
    create table(:answer_votes) do
      add :vote, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :answer_id, references(:answers, on_delete: :delete_all)

      timestamps()
    end

    create index(:answer_votes, [:user_id])
    create index(:answer_votes, [:answer_id])
    create unique_index(:answer_votes, [:user_id, :answer_id])
  end
end

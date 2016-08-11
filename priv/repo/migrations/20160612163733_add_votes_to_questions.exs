defmodule Howtosay.Repo.Migrations.AddVotesToQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :votes, :integer, default: 0, null: false
    end
  end
end

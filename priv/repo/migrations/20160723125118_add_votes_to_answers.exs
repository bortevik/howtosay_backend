defmodule Howtosay.Repo.Migrations.AddVotesToAnswers do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :votes, :integer, default: 0
    end
  end
end

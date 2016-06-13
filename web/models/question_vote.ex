defmodule Howtosay.QuestionVote do
  use Howtosay.Web, :model

  schema "question_votes" do
    field :vote, :integer
    belongs_to :user, Howtosay.User
    belongs_to :question, Howtosay.Question

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(vote user_id question_id), [])
    |> validate_inclusion(:vote, [1, -1])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:question_id)
    |> unique_constraint(:question_id, name: :question_votes_user_id_question_id_index,
                                       message: "The question has already been voted")
  end
end

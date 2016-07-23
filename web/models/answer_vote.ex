defmodule Howtosay.AnswerVote do
  use Howtosay.Web, :model

  schema "answer_votes" do
    field :vote, :integer
    belongs_to :user, Howtosay.User
    belongs_to :answer, Howtosay.Answer

    timestamps()
  end

  def changeset(:create, model, params \\ %{}) do
    model
    |> cast(params, ~w(vote user_id answer_id), [])
    |> validate_inclusion(:vote, [1, -1])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:answer_id)
    |> unique_constraint(:answer_id, name: :answer_votes_user_id_answer_id_index,
                                     message: "The answer has already been voted")
  end
end

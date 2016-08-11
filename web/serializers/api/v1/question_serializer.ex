defmodule Howtosay.Api.V1.QuestionSerializer do
  use JaSerializer

  alias Howtosay.Repo
  import Ecto.Query, only: [where: 2, select: 3]
  import Ecto, only: [assoc: 2]

  location "/api/v1/questions/:id"
  attributes [:text, :votes, :inserted_at, :updated_at, :answers_count]

  has_one :language_from, field: :language_from_id, type: "language"
  has_one :language_to, field: :language_to_id, type: "language"
  has_one :user,
    serializer: Howtosay.Api.V1.UserSerializer,
    include: true

  def user(question, _conn) do
    case question.user do
      %Ecto.Association.NotLoaded{} ->
        question
        |> assoc(:user)
        |> Repo.one()
      other -> other
    end
  end

  def answers_count(question, _conn) do
    Howtosay.Answer
    |> where(question_id: ^question.id)
    |> select([a], count(a.id))
    |> Repo.one()
  end
end


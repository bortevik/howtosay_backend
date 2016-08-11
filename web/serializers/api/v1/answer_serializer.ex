defmodule Howtosay.Api.V1.AnswerSerializer do
  use JaSerializer

  location "/api/v1/answers/:id"
  attributes [:text, :votes, :inserted_at, :updated_at]

  has_one :question, field: :question_id, type: "question"
  has_one :user,
    serializer: Howtosay.Api.V1.UserSerializer,
    include: true


  def user(answer, _conn) do
    case answer.user do
      %Ecto.Association.NotLoaded{} ->
        answer
        |> Ecto.assoc(:user)
        |> Howtosay.Repo.one()
      other -> other
    end
  end

  def votes(answer, _conn) do
    answer.votes || 0
  end
end

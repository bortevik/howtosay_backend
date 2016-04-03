defmodule Howtosay.Api.V1.AnswerSerializer do
  use JaSerializer

  location "/api/v1/answers/:id"
  attributes [:text, :inserted_at, :updated_at]

  has_one :question, field: :question_id, type: "question"
  has_one :user,
    serializer: Howtosay.Api.V1.UserSerializer,
    include: true


  def user(answer, conn) do
    case answer.user do
      %Ecto.Association.NotLoaded{} ->
        answer
        |> Ecto.Model.assoc(:user)
        |> Howtosay.Repo.one()
      other -> other
    end
  end
end

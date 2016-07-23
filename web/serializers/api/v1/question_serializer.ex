defmodule Howtosay.Api.V1.QuestionSerializer do
  use JaSerializer

  location "/api/v1/questions/:id"
  attributes [:text, :votes, :inserted_at, :updated_at]

  has_one :language_from, field: :language_from_id, type: "language"
  has_one :language_to, field: :language_to_id, type: "language"
  has_one :user,
    serializer: Howtosay.Api.V1.UserSerializer,
    include: true

  def user(question, _conn) do
    case question.user do
      %Ecto.Association.NotLoaded{} ->
        question
        |> Ecto.assoc(:user)
        |> Howtosay.Repo.one()
      other -> other
    end
  end
end


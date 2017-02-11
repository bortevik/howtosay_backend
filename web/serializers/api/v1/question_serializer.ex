defmodule Howtosay.Api.V1.QuestionSerializer do
  use JaSerializer

  alias Howtosay.Repo
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

  def votes(question, _conn) do
    question.votes || 0
  end
end


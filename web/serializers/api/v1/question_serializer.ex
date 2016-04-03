defmodule Howtosay.Api.V1.QuestionSerializer do
  use JaSerializer

  location "/api/v1/questions/:id"
  attributes [:text, :inserted_at, :updated_at]

  has_one :language_from, field: :language_from_id, type: "language"
  has_one :language_to, field: :language_to_id, type: "language"
  has_one :user,
    serializer: Howtosay.Api.V1.UserSerializer,
    include: true
end

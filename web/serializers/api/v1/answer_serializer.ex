defmodule Howtosay.Api.V1.AnswerSerializer do
  use JaSerializer

  location "/api/v1/answers/:id"
  attributes [:text, :inserted_at, :updated_at]

  has_one :question, field: :question_id, type: "question"
  has_one :user, field: :user_id, type: "user"
end

defmodule Howtosay.Api.V1.AnswerSerializer do
  use JaSerializer

  location "/api/v1/answers/:id"
  attributes [:text, :inserted_at]

  has_one :question, field: :question_id, type: "question"
end

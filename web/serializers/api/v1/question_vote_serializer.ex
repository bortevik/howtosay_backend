defmodule Howtosay.Api.V1.QuestionVoteSerializer do
  use JaSerializer

  location "/api/v1/question_votes/:id"
  attributes [:vote]

  has_one :question, field: :question_id, type: "question"
  has_one :user, field: :user_id, type: "user"
end

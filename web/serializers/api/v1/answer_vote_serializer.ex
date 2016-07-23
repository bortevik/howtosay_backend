defmodule Howtosay.Api.V1.AnswerVoteSerializer do
  use JaSerializer

  location "/api/v1/answer_votes/:id"
  attributes [:vote]

  has_one :answer, field: :answer_id, type: "answer"
  has_one :user, field: :user_id, type: "user"
end

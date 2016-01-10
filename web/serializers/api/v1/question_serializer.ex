defmodule Howtosay.Api.V1.QuestionSerializer do
  use JaSerializer

  location "/api/v1/questions/:id"
  attributes [:text, :inserted_at]
end

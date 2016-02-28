defmodule Howtosay.Api.V1.UserSerializer do
  use JaSerializer

  location "/api/v1/users/:id"
  attributes [:name]

  has_one :language, field: :language_id, type: "language"
end

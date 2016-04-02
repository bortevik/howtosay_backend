defmodule Howtosay.Api.V1.UserSerializer do
  use JaSerializer

  location "/api/v1/users/:id"
  attributes [:name, :language_to_ids]

  has_one :language, field: :language_id, type: "language"
end

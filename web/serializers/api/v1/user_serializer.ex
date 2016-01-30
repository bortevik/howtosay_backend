defmodule Howtosay.Api.V1.UserSerializer do
  use JaSerializer

  location "/api/v1/users/:id"
  attributes [:name]
end

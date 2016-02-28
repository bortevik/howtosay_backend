defmodule Howtosay.Api.V1.LanguageSerializer do
  use JaSerializer

  location "/api/v1/languages/:id"
  attributes [:code, :name]
end

defmodule Howtosay.Api.V1.UserSerializer do
  use JaSerializer

  location "/api/v1/users/:id"
  attributes [:name, :language_to_ids]

  has_one :language, field: :language_id, type: "language"

  def language_to_ids(user, conn) do
    user_id = user.id

    case Guardian.Plug.current_resource(conn) do
      %Howtosay.User{id: ^user_id} -> user.language_to_ids
      _ -> []
    end
  end
end


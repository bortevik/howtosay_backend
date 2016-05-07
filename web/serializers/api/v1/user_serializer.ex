defmodule Howtosay.Api.V1.UserSerializer do
  use JaSerializer

  location "/api/v1/users/:id"
  attributes [:name, :language_to_ids]

  has_one :language, field: :language_id, type: "language"

  def language_to_ids(user, conn) do
    user_id = user.id
    current_user_id =
      with current_user <- Guardian.Plug.current_resource(conn),
       do: current_user.id

    case current_user_id do
      ^user_id -> user.language_to_ids
      _ -> []
    end
  end
end


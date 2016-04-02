defmodule Howtosay.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias Howtosay.Api.V1.UserSerializer

  def apply_relation(params, relations, relation) do
    id = relations[relation]["data"]["id"]
    Map.put(params, relation <> "_id", id)
  end

  def error_json(conn, status, error) do
    conn
    |> put_status(status)
    |> json(get_error(error, conn))
  end

  def handle_own_resource_authorization(conn, resource_user_id) do
    current_user_id = Guardian.Plug.current_resource(conn).id

    case resource_user_id do
      ^current_user_id ->
        conn
      _ ->
        conn |> put_status(403) |> json(nil) |> halt()
    end
  end

  def response_with_token(conn, user, claims, jwt) do
    exp = Map.get(claims, "exp")
    response_json = user |> UserSerializer.format(conn) |> Map.put(:token, jwt)

    conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> json(response_json)
  end

  defp get_error(%Ecto.Changeset{} = changeset, conn) do
    JaSerializer.EctoErrorSerializer.format(changeset, conn)
  end

  defp get_error(error, _), do: error
end

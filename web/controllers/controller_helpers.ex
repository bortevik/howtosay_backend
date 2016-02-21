defmodule Howtosay.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias Howtosay.Api.V1.UserSerializer

  def error_json(conn, status, error) do
    conn
    |> put_status(status)
    |> json(get_error(error, conn))
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

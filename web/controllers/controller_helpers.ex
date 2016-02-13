defmodule Howtosay.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias Howtosay.Api.V1.UserSerializer

  def error_json(conn, status, changeset) do
    conn
    |> put_status(status)
    |> json(JaSerializer.EctoErrorSerializer.format(changeset, conn))
  end

  def response_with_token(conn, user, claims, jwt) do
    exp = Map.get(claims, "exp")
    response_json = user |> UserSerializer.format(conn) |> Map.put(:token, jwt)

    conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> json(response_json)
  end
end

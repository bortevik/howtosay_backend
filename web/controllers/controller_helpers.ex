defmodule Howtosay.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def error_json(conn, status, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(JaSerializer.EctoErrorSerializer(changeset, conn))
  end
end

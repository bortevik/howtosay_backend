defmodule Howtosay.ControllerHelpers do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

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

  defp get_error(%Ecto.Changeset{} = changeset, conn) do
    JaSerializer.EctoErrorSerializer.format(changeset, conn)
  end

  defp get_error(error, _), do: error

  def send_confirmation_email(conn, user) do
    client_host = Application.get_env :howtosay, :client_host
    link = client_host <> "/confirm-email/" <> user.confirmation_token

    Howtosay.Mailer.send_confirmation_email(user.email, %{confirmation_link: link})
    conn
  end
end

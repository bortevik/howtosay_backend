defmodule Howtosay.Api.V1.SessionController do
  use Howtosay.Web, :controller

  alias Howtosay.User
  alias Howtosay.Api.V1.UserSerializer

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:update]
  plug :scrub_params, "email" when action in [:create]
  plug :scrub_params, "password" when action in [:create]
  plug :scrub_params, "token" when action in [:update]

  def create(conn, params) do
    user = User |> where(email: ^params["email"]) |> Repo.one

    if user do
      changeset = User.login_changeset(user, params)

      if changeset.valid? do
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        jwt = Guardian.Plug.current_token(new_conn)

        response_with_token(new_conn, user, claims, jwt)
      else
        send_resp(conn, 401, "")
      end
    else
      send_resp(conn, 401, "")
    end
  end

  def update(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    user = Guardian.Plug.current_resource(conn)

    case Guardian.refresh!(jwt) do
      {:ok, new_jwt, new_claims} ->
        response_with_token(conn, user, new_claims, new_jwt)
      {:error, _reason} ->
        send_resp(conn, 401, "")
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)

    Guardian.revoke!(jwt, claims)
    send_resp(conn, :no_content, "")
  end

  def unauthenticated(conn, _params) do
    send_resp(conn, 401, "")
  end

  defp response_with_token(conn, user, claims, jwt) do
    exp = Map.get(claims, "exp")
    response_json = user |> UserSerializer.format(conn) |> Map.put(:token, jwt)

    conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> json(response_json)
  end
end

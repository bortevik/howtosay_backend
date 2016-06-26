defmodule Howtosay.Api.V1.SessionController do
  use Howtosay.Web, :controller

  alias Howtosay.User

  plug Guardian.Plug.EnsureAuthenticated, %{handler: __MODULE__} when action in [:update]
  plug :scrub_params, "email" when action in [:create]
  plug :scrub_params, "password" when action in [:create]
  plug :scrub_params, "token" when action in [:update]

  def create(conn, params) do
    user = Repo.get_by User, email: params["email"]

    if user do
      changeset = User.login_changeset(user, params)

      if changeset.valid? do
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        jwt = Guardian.Plug.current_token(new_conn)

        respond_with_token(new_conn, claims, jwt)
      else
        case Keyword.fetch(changeset.errors, :email) do
          {:ok, {message, []}} ->
            error_json(conn, 401, %{error: "Email " <> message})
          :error ->
            error_json(conn, 401, %{error: "Wrong email or password"})
        end
      end
    else
      error_json(conn, 401, %{error: "Wrong email or password"})
    end
  end

  def update(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)

    case Guardian.refresh!(jwt) do
      {:ok, new_jwt, new_claims} ->
        respond_with_token(conn, new_claims, new_jwt)
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

  defp respond_with_token(conn, claims, jwt) do
    exp = Map.get(claims, "exp")

    conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> json(%{token: jwt})
  end
end

defmodule Howtosay.Api.V1.EmailConfirmationController do
  use Howtosay.Web, :controller

  alias Howtosay.User

  plug :scrub_params, "email" when action in [:resend_confirmation_email]
  plug :scrub_params, "token" when action in [:confirm_email]

  def resend_confirmation_email(conn, %{"email" => email}) do
    user = Repo.get_by(User, email: email)

    case user do
      nil ->
        conn |> put_status(404) |> json(nil)
      user ->
        send_confirmation_email(conn, user)
        |> put_status(200)
        |> json(nil)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    result = with %User{} = user <- Repo.get_by(User, confirmation_token: token),
      do: User.confirm_email(user)

    case result do
      {:ok, user} ->
        new_conn = Guardian.Plug.api_sign_in(conn, user)
        {:ok, claims} = Guardian.Plug.claims(new_conn)
        jwt = Guardian.Plug.current_token(new_conn)

        respond_with_token(new_conn, claims, jwt)
      _ ->
        conn |> put_status(422) |> json(nil)
    end
  end

  defp respond_with_token(conn, claims, jwt) do
    exp = Map.get(claims, "exp")

    conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> json(%{token: jwt})
  end
end

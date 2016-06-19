defmodule Howtosay.Api.V1.UserController do
  use Howtosay.Web, :controller

  alias Howtosay.User
  alias Howtosay.Api.V1.{SessionController, UserSerializer}

  plug Guardian.Plug.EnsureAuthenticated, %{ handler: SessionController} when action in [:update, :delete, :current_user]
  plug :authorize_for_own_resource when action in [:update, :delete]
  plug :scrub_params, "data" when action in [:create, :update]

  def current_user(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        send_resp(conn, 401, "")
      user ->
        json conn, UserSerializer.format(user, conn)
    end
  end

  def create(conn, %{"data" => %{"attributes" => params, "relationships" => relations}}) do
    user_params = apply_relation(params, relations, "language")
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> send_confirmation_email(user)
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> json(UserSerializer.format(user, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      answer ->
        json conn, UserSerializer.format(answer, conn)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => params, "relationships" => relations}}) do
    user_params = apply_relation(params, relations, "language")
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        # if email changed send confirmation email
        json conn, UserSerializer.format(user, conn)
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    Repo.delete!(user)
    send_resp(conn, :no_content, "")
  end

  defp authorize_for_own_resource(conn, _) do
    user_id = conn.params["id"] |> String.to_integer()

    handle_own_resource_authorization(conn, user_id)
  end
end

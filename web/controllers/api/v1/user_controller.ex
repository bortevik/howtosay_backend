defmodule Howtosay.Api.V1.UserController do
  use Howtosay.Web, :controller
  use Guardian.Phoenix.Controller

  alias Howtosay.User
  alias Howtosay.Api.V1.UserSerializer
  alias Howtosay.SessionController

  plug Guardian.Plug.EnsureAuthenticated, %{ handler: SessionController} when not action in [:create, :show]
  plug :authorize_for_own_resource when action in [:update, :delete]
  plug :scrub_params, "data" when action in [:create, :update]

  def create(conn, %{"data" => %{"attributes" => user_params}}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> send_confirmation_email(user)
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> json(UserSerializer.format(user))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Howtosay.ChangesetView, "error.json", changeset: changeset)
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

  def update(conn, %{"id" => id, "data" => %{"attributes" => user_params}}) do
    user = Repo.get!(User, id)
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        # if email changed send confirmation email
        json conn, UserSerializer.format(user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Howtosay.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    Repo.delete!(user)
    send_resp(conn, :no_content, "")
  end

  def authorize_for_own_resource(conn, %{"id" => id}) do
    current_user_id = Guardian.Plug.current_resource(conn).id
    case String.to_integer(id) do
      ^current_user_id ->
        conn
      _ ->
        conn |> put_status(403) |> json(nil) |> halt()
    end
  end

  def send_confirmation_email(conn, user) do
    client_host = Application.get_env :howtosay, :client_host
    link = client_host <> "/email_confirmation/" <> user.confirmation_token

    Howtosay.Mailer.send_confirmation_email(user.email, %{confirmation_link: link})
    conn
  end
end

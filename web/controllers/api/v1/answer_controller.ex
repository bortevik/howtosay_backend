defmodule Howtosay.Api.V1.AnswerController do
  use Howtosay.Web, :controller

  alias Howtosay.Answer
  alias Howtosay.Api.V1.AnswerSerializer

  plug Guardian.Plug.EnsureAuthenticated, %{ handler: SessionController} when action in [:create, :update, :delete]
  plug :authorize_for_own_resource when action in [:update, :delete]
  plug :scrub_params, "id" when action in [:show, :update, :delete]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"question_id" => question_id}) do
    answers =
      Answer
      |> where(question_id: ^question_id)
      |> order_by(asc: :id)
      |> preload(:user)
      |> Repo.all()
      |> serialize(conn)

    json(conn, answers)
  end

  def index(conn, _), do: json(conn, %{})

  def create(conn, %{"data" => %{"attributes" => attrs, "relationships" => relations}}) do
    current_user_id = Guardian.Plug.current_resource(conn).id
    params =
      attrs
      |> apply_relation(relations, "question")
      |> Map.put("user_id", current_user_id)

    changeset = Answer.create_changeset(%Answer{}, params)

    case Repo.insert(changeset) do
      {:ok, answer} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", answer_path(conn, :show, answer))
        |> json(serialize(answer, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Answer, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      answer ->
        json conn, serialize(answer, conn)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => answer_params}}) do
    answer = Repo.get!(Answer, id)
    changeset = Answer.update_changeset(answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        json(conn, serialize(answer, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)

    Repo.delete!(answer)

    send_resp(conn, :no_content, "")
  end

  defp authorize_for_own_resource(conn, _) do
    with %Howtosay.Answer{user_id: user_id} <- Repo.get(Answer, conn.params["id"]),
     do: handle_own_resource_authorization(conn, user_id)
  end

  defp serialize(data, conn) do
    JaSerializer.format(AnswerSerializer, data, conn)
  end
end

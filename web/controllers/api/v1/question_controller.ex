defmodule Howtosay.Api.V1.QuestionController do
  use Howtosay.Web, :controller

  alias Howtosay.Question
  alias Howtosay.Api.V1.QuestionSerializer

  plug Guardian.Plug.EnsureAuthenticated, %{ handler: SessionController} when action in [:create, :update, :delete]
  plug :authorize_for_own_resource when action in [:update, :delete]
  plug :scrub_params, "id" when action in [:show, :update, :delete]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, params) do
    questions =
      Question
      |> filter_by_langauge_from(params["language_from_id"])
      |> filter_by_language_to(params["language_to_ids"])
      |> order_by(desc: :id)
      |> Repo.paginate(page: params["page"]["page"] || 1, page_size: params["page"]["page_size"] || 100)
      |> QuestionSerializer.format(conn)

    json(conn, questions)
  end

  def create(conn, %{"data" => %{"attributes" => params, "relationships" => relations}}) do
    current_user_id = Guardian.Plug.current_resource(conn).id
    question_params =
      params
      |> apply_relation(relations, "language_from")
      |> apply_relation(relations, "language_to")
      |> Map.put("user_id", current_user_id)
    changeset = Question.create_changeset(%Question{}, question_params)

    case Repo.insert(changeset) do
      {:ok, question} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", question_path(conn, :show, question))
        |> json(QuestionSerializer.format(question, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Question, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      question ->
        json conn, QuestionSerializer.format(question, conn)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => question_params}}) do
    question = Repo.get!(Question, id)
    changeset = Question.update_changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        json(conn, QuestionSerializer.format(question, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)

    Repo.delete!(question)

    send_resp(conn, :no_content, "")
  end

  defp filter_by_langauge_from(query, nil), do: query
  defp filter_by_langauge_from(query, id), do: query |> where(language_from_id: ^id)

  defp filter_by_language_to(query, nil), do: query
  defp filter_by_language_to(query, ids), do: query |> where([q], q.language_to_id in ^ids)

  defp authorize_for_own_resource(conn, _) do
    user_id = with question <- Repo.get(Question, conn.params["id"]),
                   do: question.user_id

    handle_own_resource_authorization(conn, user_id)
  end
end

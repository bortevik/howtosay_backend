defmodule Howtosay.Api.V1.QuestionController do
  use Howtosay.Web, :controller

  alias Howtosay.Question
  alias Howtosay.Api.V1.QuestionSerializer

  plug :scrub_params, "id" when action in [:show, :update, :delete]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    questions =
      Question
      |> order_by(desc: :id)
      |> Repo.all()
      |> QuestionSerializer.format(conn)

    json(conn, questions)
  end

  def create(conn, %{"data" => %{"attributes" => question_params}}) do
    changeset = Question.changeset(%Question{}, question_params)

    case Repo.insert(changeset) do
      {:ok, question} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", question_path(conn, :show, question))
        |> json(QuestionSerializer.format(question, conn))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Howtosay.ChangesetView, "error.json", changeset: changeset)
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
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        json(conn, QuestionSerializer.format(question, conn))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Howtosay.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)

    Repo.delete!(question)

    send_resp(conn, :no_content, "")
  end
end

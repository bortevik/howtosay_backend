defmodule Howtosay.Api.V1.AnswerController do
  use Howtosay.Web, :controller

  alias Howtosay.Answer
  alias Howtosay.Api.V1.AnswerSerializer

  plug :scrub_params, "id" when action in [:show, :update, :delete]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"question_id" => question_id}) do
    answers =
      Answer
      |> where(question_id: ^question_id)
      |> order_by(asc: :id)
      |> Repo.all()
      |> AnswerSerializer.format(conn)

    json(conn, answers)
  end

  def index(conn, _), do: json(conn, %{})

  def create(conn, %{"data" => data}) do
    question_id = data["relationships"]["question"]["data"]["id"]
    params = data["attributes"] |> Map.put("question_id", question_id)
    changeset = Answer.changeset(%Answer{}, params)

    case Repo.insert(changeset) do
      {:ok, answer} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", answer_path(conn, :show, answer))
        |> json(AnswerSerializer.format(answer, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Answer, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      answer ->
        json conn, AnswerSerializer.format(answer, conn)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => answer_params}}) do
    answer = Repo.get!(Answer, id)
    changeset = Answer.changeset(answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        json(conn, AnswerSerializer.format(answer, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    answer = Repo.get!(Answer, id)

    Repo.delete!(answer)

    send_resp(conn, :no_content, "")
  end
end

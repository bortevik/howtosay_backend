defmodule Howtosay.Api.V1.QuestionVoteController do
  use Howtosay.Web, :controller

  alias Howtosay.QuestionVote
  alias Howtosay.Question
  alias Howtosay.Api.V1.QuestionVoteSerializer

  def create(conn, %{"data" => %{"attributes" => attrs, "relationships" => relations}}) do
    current_user_id = Guardian.Plug.current_resource(conn).id
    params =
      attrs
      |> apply_relation(relations, "question")
      |> Map.put("user_id", current_user_id)

    changeset = QuestionVote.changeset(:create, %QuestionVote{}, params)

    case Repo.insert(changeset) do
      {:ok, vote} ->
        calculate_question_votes(vote)

        conn
        |> put_status(:created)
        |> put_resp_header("location", question_vote_path(conn, :show, vote))
        |> json(serialize(vote, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(QuestionVote, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      answer ->
        json conn, serialize(answer, conn)
    end
  end

  defp calculate_question_votes(%QuestionVote{vote: vote, question_id: question_id}) do
    with %Question{} = question <- Repo.get(Question, question_id),
         %Ecto.Changeset{} = changeset <- Ecto.Changeset.change(question, votes: question.votes + vote),
     do: Repo.update(changeset)
  end

  defp serialize(data, conn) do
    JaSerializer.format(QuestionVoteSerializer, data, conn)
  end
end

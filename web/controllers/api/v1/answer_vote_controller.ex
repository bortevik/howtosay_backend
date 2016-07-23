defmodule Howtosay.Api.V1.AnswerVoteController do
  use Howtosay.Web, :controller

  alias Howtosay.AnswerVote
  alias Howtosay.Answer
  alias Howtosay.Api.V1.AnswerVoteSerializer

  def create(conn, %{"data" => %{"attributes" => attrs, "relationships" => relations}}) do
    current_user_id = Guardian.Plug.current_resource(conn).id
    params =
      attrs
      |> apply_relation(relations, "answer")
      |> Map.put("user_id", current_user_id)

    changeset = AnswerVote.changeset(:create, %AnswerVote{}, params)

    case Repo.insert(changeset) do
      {:ok, vote} ->
        calculate_answer_votes(vote)

        conn
        |> put_status(:created)
        |> put_resp_header("location", answer_vote_path(conn, :show, vote))
        |> json(serialize(vote, conn))
      {:error, changeset} ->
        error_json conn, 422, changeset
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(AnswerVote, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      answer ->
        json conn, serialize(answer, conn)
    end
  end

  defp calculate_answer_votes(%AnswerVote{vote: vote, answer_id: answer_id}) do
    with %Answer{} = answer <- Repo.get(Answer, answer_id),
         %Ecto.Changeset{} = changeset <- Ecto.Changeset.change(answer, votes: answer.votes + vote),
     do: Repo.update(changeset)
  end

  defp serialize(data, conn) do
    JaSerializer.format(AnswerVoteSerializer, data, conn)
  end
end

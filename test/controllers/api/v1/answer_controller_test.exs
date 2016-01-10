defmodule Howtosay.Api.V1.AnswerControllerTest do
  use Howtosay.ConnCase

  alias Howtosay.Answer
  alias Howtosay.Question
  @valid_attrs %{text: "some content"}
  @invalid_attrs %{text: ""}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    question = Repo.insert! %Question{text: "question one"}
    answer = Repo.insert! %Answer{text: "some answer", question_id: question.id}

    {:ok, conn: conn, question: question, answer: answer}
  end

  test "lists answers of specifyed question on index", %{conn: conn, question: question, answer: one} do
    two = Repo.insert! %Answer{text: "bar", question_id: question.id}

    another_question = Repo.insert! %Question{text: "quesiton two"}
    three = Repo.insert! %Answer{text: "baz", question_id: another_question.id}

    conn = get conn, answer_path(conn, :index), question_id: question.id
    json = json_response(conn, 200)["data"]

    assert length(json) == 2
    assert List.first(json)["attributes"]["text"] == one.text
    assert List.last(json)["attributes"]["text"] == two.text
  end

  test "shows answer", %{conn: conn, question: question, answer: answer} do
    conn = get conn, answer_path(conn, :show, answer)
    json_data =json_response(conn, 200)["data"]

    assert json_data["attributes"]["text"] == answer.text
    assert json_data["attributes"]["inserted-at"] == Ecto.DateTime.to_iso8601 answer.inserted_at
    assert json_data["relationships"]["question"]["data"]["id"] == "#{question.id}"
  end

  test "shows error when there is no particular answer", %{conn: conn} do
    conn = get conn, answer_path(conn, :show, -1)
    assert response(conn, 404)
  end

  test "creates and renders answer when data is valid", %{conn: conn, question: question} do
    params =
      %{attributes: @valid_attrs}
      |> Map.put(:relationships, %{question: %{data:  %{id: question.id, type: "question"}}})
    conn = post conn, answer_path(conn, :create), Poison.encode!(%{data: params})

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not create answer and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), Poison.encode!(%{data: %{attributes: @invalid_attrs}})
    errors = %{"question_id" => ["can't be blank"], "text" => ["can't be blank"]}
    assert json_response(conn, 422)["errors"] == errors
  end

  test "updates and renders answer when data is valid", %{conn: conn, answer: answer} do
    conn = put conn, answer_path(conn, :update, answer), Poison.encode!(%{data: %{attributes: @valid_attrs}})
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not update answer and renders errors when data is invalid", %{conn: conn, answer: answer} do
    conn = put conn, answer_path(conn, :update, answer), Poison.encode!(%{data: %{attributes: @invalid_attrs}})
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, answer: answer} do
    conn = delete conn, answer_path(conn, :delete, answer)
    assert response(conn, 204)
    refute Repo.get(Answer, answer.id)
  end
end

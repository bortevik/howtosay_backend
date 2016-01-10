defmodule Howtosay.Api.V1.QuestionControllerTest do
  use Howtosay.ConnCase

  alias Howtosay.Question
  @valid_attrs %{text: "some content"}
  @invalid_attrs %{text: ""}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all questions on index", %{conn: conn} do
    one = Repo.insert! %Question{text: "foo"}
    two = Repo.insert! %Question{text: "bar"}

    conn = get conn, question_path(conn, :index)
    json = json_response(conn, 200)["data"]

    assert length(json) == 2
    assert List.first(json)["attributes"]["text"] == two.text
    assert List.last(json)["attributes"]["text"] == one.text
  end

  test "shows question", %{conn: conn} do
    question = Repo.insert! %Question{text: "foo"}
    conn = get conn, question_path(conn, :show, question)

    json_data = json_response(conn, 200)["data"]
    assert json_data["id"] == "#{question.id}"
    assert json_data["attributes"]["text"] == question.text
    assert json_data["attributes"]["inserted-at"] == Ecto.DateTime.to_iso8601 question.inserted_at
  end

  test "does not show question and instead throw error when id is nonexistent", %{conn: conn} do
    conn = get conn, question_path(conn, :show, -1)
    assert response(conn, 404)
  end

  test "creates and renders question when data is valid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), Poison.encode!(%{data: %{attributes: @valid_attrs}})
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Question, @valid_attrs)
  end

  test "does not create question and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, question_path(conn, :create), Poison.encode!(%{data: %{attributes: @invalid_attrs}})
    assert json_response(conn, 422)["errors"] == %{"text" => ["can't be blank"]}
  end

  test "updates and renders question when data is valid", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = put conn, question_path(conn, :update, question), Poison.encode!(%{data: %{attributes: @valid_attrs}})
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Question, @valid_attrs)
  end

  test "does not update question and renders errors when data is invalid", %{conn: conn} do
    question = Repo.insert! %Question{text: "some"}
    conn = put conn, question_path(conn, :update, question), Poison.encode!(%{data: %{attributes: @invalid_attrs}})
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes question", %{conn: conn} do
    question = Repo.insert! %Question{}
    conn = delete conn, question_path(conn, :delete, question)
    assert response(conn, 204)
    refute Repo.get(Question, question.id)
  end
end

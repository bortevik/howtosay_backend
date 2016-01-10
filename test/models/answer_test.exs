defmodule Howtosay.AnswerTest do
  use Howtosay.ModelCase

  alias Howtosay.Answer
  alias Howtosay.Question

  @valid_attrs %{text: "some content"}
  @invalid_attrs %{text: nil}

  test "changeset with valid attributes" do
    question = Howtosay.Repo.insert! %Question{text: "some question"}
    changeset = Answer.changeset(%Answer{question_id: question.id}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset is invalid without text" do
    question = Howtosay.Repo.insert! %Question{text: "some question"}
    changeset = Answer.changeset(%Answer{question_id: question.id}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset is invalid without question" do
    changeset = Answer.changeset(%Answer{text: "some"})
    refute changeset.valid?
  end
end

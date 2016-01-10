defmodule Howtosay.QuestionTest do
  use Howtosay.ModelCase

  alias Howtosay.Question

  @valid_attrs %{text: "some content"}
  @invalid_attrs %{text: nil}

  test "changeset with valid attributes" do
    changeset = Question.changeset(%Question{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset is invalid without text" do
    changeset = Question.changeset(%Question{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule Howtosay.QuestionVoteTest do
  use Howtosay.ModelCase

  alias Howtosay.QuestionVote

  @valid_attrs %{vote: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = QuestionVote.changeset(%QuestionVote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = QuestionVote.changeset(%QuestionVote{}, @invalid_attrs)
    refute changeset.valid?
  end
end

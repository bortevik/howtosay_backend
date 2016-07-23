defmodule Howtosay.AnswerVoteTest do
  use Howtosay.ModelCase

  alias Howtosay.AnswerVote

  @valid_attrs %{vote: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AnswerVote.changeset(%AnswerVote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AnswerVote.changeset(%AnswerVote{}, @invalid_attrs)
    refute changeset.valid?
  end
end

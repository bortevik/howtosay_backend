defmodule Howtosay.UserTest do
  use Howtosay.ModelCase

  alias Howtosay.User

  @valid_attrs %{confirmation_token: "some content", confirmed_at: "2010-04-17 14:00:00", email: "some content", hashed_password: "some content", name: "some content", password_reset_token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end

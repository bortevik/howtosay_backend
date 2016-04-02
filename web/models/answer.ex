defmodule Howtosay.Answer do
  use Howtosay.Web, :model

  schema "answers" do
    field :text, :string
    belongs_to :question, Howtosay.Question
    belongs_to :user, Howtosay.User

    timestamps
  end

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(text question_id user_id), [])
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:user_id)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(text), [])
  end
end

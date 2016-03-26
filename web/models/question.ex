defmodule Howtosay.Question do
  use Howtosay.Web, :model

  schema "questions" do
    field :text, :string

    has_many :answers, Howtosay.Answer
    belongs_to :user, Howtosay.User
    belongs_to :language_from, Howtosay.Language
    belongs_to :language_to, Howtosay.Language

    timestamps
  end

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(text language_from_id language_to_id), [])
    |> foreign_key_constraint(:language_from_id)
    |> foreign_key_constraint(:language_to_id)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(text), [])
  end
end

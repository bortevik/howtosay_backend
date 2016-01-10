defmodule Howtosay.Answer do
  use Howtosay.Web, :model

  schema "answers" do
    field :text, :string
    belongs_to :question, Howtosay.Question

    timestamps
  end

  @required_fields ~w(text question_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:question_id)
  end
end

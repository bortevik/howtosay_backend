defmodule Howtosay.Question do
  use Howtosay.Web, :model

  schema "questions" do
    field :text, :string
    has_many :answers, Howtosay.Answer

    timestamps
  end

  @required_fields ~w(text)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

defmodule Howtosay.Language do
  use Howtosay.Web, :model

  schema "languages" do
    field :name, :string
    field :code, :string

    timestamps
  end

  @required_fields ~w(name code)

  # def changeset(model, params \\ :empty) do
  #   model
  #   |> cast(params, @required_fields, [])
  # end
end

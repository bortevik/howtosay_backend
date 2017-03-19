defmodule Howtosay.Language do
  use Howtosay.Web, :model

  schema "languages" do
    field :name, :string
    field :code, :string

    has_many :users, Howtosay.User
    has_many :questions, Howtosay.Question

    timestamps()
  end

  # @required_fields ~w(name code)

  # def changeset(model, params \\ %{}) do
  #   model
  #   |> cast(params, @required_fields, [])
  # end
end

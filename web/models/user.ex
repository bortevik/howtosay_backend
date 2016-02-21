defmodule Howtosay.User do
  use Howtosay.Web, :model

  alias Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :hashed_password, :string
    field :confirmation_token, :string
    field :confirmed_at, Ecto.DateTime
    field :password_reset_token, :string
    field :password, :string, virtual: true

    has_many :questions, Howtosay.Question
    has_many :answers, Howtosay.Answer

    timestamps
  end

  def changeset(changeset) do
    changeset
    |> validate_length(:name, min: 1, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name email password), [])
    |> changeset()
    |> put_confirmation_token()
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, [], ~w(name email password))
    |> changeset()
  end

  def login_changeset(model, params) do
    model
    |> cast(params, ~w(email password), ~w())
    |> validate_password
    |> fetch_confirmation
  end

  def confirm_email(model) do
    model
    |> change(%{confirmation_token: nil, confirmed_at: Ecto.DateTime.utc()})
    |> Repo.update()
  end

  def valid_password?(nil, _), do: false
  def valid_password?(_, nil), do: false
  def valid_password?(password, crypted), do: Comeonin.Pbkdf2.checkpw(password, crypted)

  defp put_password_hash(changeset) do
    case Changeset.fetch_change(changeset, :password) do
      { :ok, password } ->
        changeset
        |> Changeset.put_change(:hashed_password, Comeonin.Pbkdf2.hashpwsalt(password))
      :error -> changeset
    end
  end

  defp put_confirmation_token(changeset) do
    changeset
    |> Changeset.put_change(:confirmation_token, generate_token())
  end

  defp validate_password(changeset) do
    case Changeset.get_field(changeset, :hashed_password) do
      nil -> password_incorrect_error(changeset)
      crypted -> validate_password(changeset, crypted)
    end
  end

  defp validate_password(changeset, crypted) do
    password = Changeset.get_change(changeset, :password)
    if valid_password?(password, crypted), do: changeset, else: password_incorrect_error(changeset)
  end

  defp password_incorrect_error(changeset), do: Changeset.add_error(changeset, :password, "is incorrect")

  defp fetch_confirmation(changeset) do
    case Changeset.fetch_field(changeset, :confirmed_at) do
      {:model, %Ecto.DateTime{}} -> changeset
      _ -> Changeset.add_error(changeset, :email, "is not confirmed")
    end
  end

  defp generate_token(length \\ 60) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end

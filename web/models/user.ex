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
    field :language_to_ids, {:array, :integer}

    has_many :questions, Howtosay.Question
    has_many :answers, Howtosay.Answer
    belongs_to :language, Howtosay.Language

    timestamps
  end

  def changeset(changeset) do
    changeset
    |> validate_length(:name, min: 1, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> put_password_hash()
    |> cast_language_to_ids()
  end

  def registration_changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(name email password), ~w(language_id language_to_ids))
    |> changeset()
    |> put_confirmation_token()
    |> ensure_lanuage_exists_or_default()
  end

  def update_changeset(model, params \\ %{}) do
    model
    |> cast(params, [], ~w(name email password language_id language_to_ids))
    |> changeset()
    |> ensure_not_nil(~w(name email password language_id)a)
    |> foreign_key_constraint(:language_id)
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
      {:data, %Ecto.DateTime{}} -> changeset
      _ -> Changeset.add_error(changeset, :email, "is not confirmed")
    end
  end

  defp generate_token(length \\ 60) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  defp ensure_lanuage_exists_or_default(changeset) do
    language_id = Changeset.get_change(changeset, :language_id)
    case get_language(language_id) do
      nil ->
        default_language = Repo.get_by(Howtosay.Language, code: "en")
        Changeset.put_change(changeset, :language_id, default_language.id)
        changeset
      _ ->
        changeset
    end
  end

  defp get_language(nil), do: nil
  defp get_language(id), do: Repo.get(Howtosay.Language, id)

  defp ensure_not_nil(changeset, []), do: changeset
  defp ensure_not_nil(changeset, [head | tail]) do
    case Changeset.get_change(changeset, head) do
      nil ->
        Changeset.delete_change(changeset, head)
        |> ensure_not_nil(tail)
      _ ->
        ensure_not_nil(changeset, tail)
    end
  end

  defp cast_language_to_ids(changeset) do
    case Changeset.get_change(changeset, :language_to_ids) do
      nil ->
        changeset
      language_ids ->
        casted_ids =
          language_ids
          |> Enum.map(&parse_integer/1)
          |> Enum.filter(&(&1))

        Changeset.put_change(changeset, :language_to_ids, casted_ids)
        changeset
    end
  end

  defp parse_integer(value) when is_integer(value), do: value
  defp parse_integer(value) when is_binary(value) do
    case Integer.parse(value) do
      :error -> nil
      {int, _} -> int
    end
  end
  defp parse_integer(_), do: nil
end


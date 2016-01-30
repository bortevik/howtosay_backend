defmodule Howtosay.Repo.Migrations.CreateGuardianDb do
  use Ecto.Migration

  def up do
    create table(:guardian_tokens, primary_key: false) do
      add :jti, :string, primary_key: true
      add :typ, :string
      add :aud, :string
      add :iss, :string
      add :sub, :string
      add :exp, :bigint
      add :jwt, :text
      add :claims, :map
      timestamps
    end
  end

  def down do
    drop table(:quardian_tokens)
  end
end

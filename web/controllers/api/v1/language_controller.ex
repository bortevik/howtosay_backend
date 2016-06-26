defmodule Howtosay.Api.V1.LanguageController do
  use Howtosay.Web, :controller

  alias Howtosay.Language
  alias Howtosay.Api.V1.LanguageSerializer

  def index(conn, _) do
    languages =
      Language
      |> Repo.all()
      |> serialize(conn)

    json(conn, languages)
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Language, id) do
      nil ->
        conn |> put_status(404) |> json(nil)
      answer ->
        json conn, serialize(answer, conn)
    end
  end

  defp serialize(data, conn) do
    JaSerializer.format(LanguageSerializer, data, conn)
  end
end

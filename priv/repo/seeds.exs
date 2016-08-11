import Howtosay.Repo, only: [insert!: 1]

alias Howtosay.User
alias Howtosay.Question
alias Howtosay.Answer
alias Howtosay.Language

defmodule Howtosay.Seed do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(key) do
    Agent.get(__MODULE__, fn map -> Map.get(map, key) end)
  end

  def update(key, value) do
    Agent.update(__MODULE__, fn map -> Map.put(map, key, value) end)
  end

  def create_user(i) do
    language = get_random_language
    user =
      %User{
        name: "Some #{i}",
        email: "some#{i}@some.com",
        hashed_password: Comeonin.Pbkdf2.hashpwsalt("123456"),
        confirmed_at: Ecto.DateTime.utc(),
        language_id: language.id
      }
      |> insert!()

    Enum.each 1..50, fn _ -> create_question(user) end
  end

  def create_question(user) do
    question =
      %Question{
        text: Faker.Lorem.Shakespeare.as_you_like_it,
        votes: round(:random.uniform() * 10),
        user_id: user.id,
        language_from_id: user.language_id,
        language_to_id: get_random_language().id
      }
      |> insert!()

    Enum.each 1..10, fn _ -> create_answer(user, question) end
  end

  def create_answer(user, question) do
    insert! %Answer{
      text: Faker.Lorem.Shakespeare.Ru.romeo_and_juliet,
      question_id: question.id,
      user_id: user.id
    }
  end

  def create_languages() do
    languages =
      [
        %Language{name: "English", code: "en"},
        %Language{name: "Russain", code: "ru"},
        %Language{name: "Arabic", code: "ar"}
      ]
      |> Enum.map(&insert!(&1))

    update(:languages, languages)
  end

  defp get_random_language() do
    :languages |> get() |> Enum.random()
  end
end

Howtosay.Seed.start_link()
Howtosay.Seed.create_languages()
Enum.each 1..5, &Howtosay.Seed.create_user/1

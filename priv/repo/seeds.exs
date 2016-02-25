import Howtosay.Repo, only: [insert!: 1]
alias Howtosay.User
alias Howtosay.Question
alias Howtosay.Answer
alias Howtosay.Language

defmodule Howtosay.Seed do
  def create_user(i) do
    user = insert! User.registration_changeset(%User{}, %{name: "Some #{i}", email: "some#{i}@some.com", password: "123456"})

    Enum.each 1..10, fn _ -> create_question(user) end
  end

  def create_question(user) do
    question = insert! %Question{text: Faker.Lorem.Shakespeare.as_you_like_it, user_id: user.id}

    Enum.each 1..10, fn _ -> create_answer(user, question) end
  end

  def create_answer(user, question) do
    insert! %Answer{text: Faker.Lorem.Shakespeare.Ru.romeo_and_juliet, question_id: question.id, user_id: user.id}
  end

  def create_languages() do
    [
      %Language{name: "English", code: "en"},
      %Language{name: "Russain", code: "ru"},
      %Language{name: "Arabic", code: "ar"}
    ]
    |> Enum.each(&insert!(&1))
  end
end

Enum.each 1..5, &Howtosay.Seed.create_user/1
Howtosay.Seed.create_languages()

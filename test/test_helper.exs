ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Howtosay.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Howtosay.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Howtosay.Repo)


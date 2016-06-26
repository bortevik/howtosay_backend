ExUnit.start(capture_log: true)

Ecto.Adapters.SQL.Sandbox.mode(Howtosay.Repo, :manual)
Ecto.Adapters.SQL.begin_test_transaction(Howtosay.Repo)


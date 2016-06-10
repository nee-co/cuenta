ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Cuenta.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Cuenta.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Cuenta.Repo)


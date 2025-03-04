ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GraphTheory.Repo, :manual)

Mox.defmock(GraphTheory.MockHTTPoison, for: HTTPoison.Base)

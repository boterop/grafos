ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(PhxLiveview.Repo, :manual)

Mox.defmock(PhxLiveview.MockHTTPoison, for: HTTPoison.Base)

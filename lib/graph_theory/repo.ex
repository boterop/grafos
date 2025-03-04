defmodule GraphTheory.Repo do
  use Ecto.Repo,
    otp_app: :graph_theory,
    adapter: Ecto.Adapters.Postgres
end

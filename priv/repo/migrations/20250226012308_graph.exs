defmodule PhxLiveview.Repo.Migrations.Graph do
  use Ecto.Migration

  def change do
    create table(:graphs, primary_key: true) do
      add :name, :string
      add :directed, :boolean, default: false
      add :nodes, {:array, :string}
      add :edges, {:array, :string}

      timestamps(type: :utc_datetime)
    end

    create unique_index(:graphs, [:name])
  end
end

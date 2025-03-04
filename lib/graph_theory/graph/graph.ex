defmodule GraphTheory.Graph do
  @moduledoc """
  Module for defining the schema for the 'graphs' table.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          directed: boolean(),
          nodes: list(String.t()),
          edges: list(String.t())
        }

  schema "graphs" do
    field :name, :string, default: ""
    field :directed, :boolean, default: false
    field :nodes, {:array, :string}, default: []
    field :edges, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(graph, attrs) do
    graph
    |> cast(attrs, [:name, :directed, :nodes, :edges])
    |> validate_required([:name, :directed, :nodes, :edges])
    |> unique_constraint(:name)
  end
end

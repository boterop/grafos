defmodule GraphTheory.Test.Fixtures.Graph do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GraphTheory.Graphs` context.
  """

  alias GraphTheory.{Graph, Repo}

  def graph_fixture(attrs \\ []) do
    name = Keyword.get(attrs, :name, "some name")
    edges = Keyword.get(attrs, :edges, [])
    nodes = Keyword.get(attrs, :nodes, [])
    directed = Keyword.get(attrs, :directed, false)

    %Graph{}
    |> Graph.changeset(%{name: name, edges: edges, nodes: nodes, directed: directed})
    |> Repo.insert!()
  end
end

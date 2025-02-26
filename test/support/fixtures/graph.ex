defmodule PhxLiveview.Test.Fixtures.Graph do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxLiveview.Graphs` context.
  """

  alias PhxLiveview.Graphs

  @doc """
  Generate a graph.
  """
  def graph_fixture(attrs \\ %{}) do
    name = Keyword.get(attrs, :name, "some name")
    edges = Keyword.get(attrs, :edges, [])
    nodes = Keyword.get(attrs, :nodes, [])

    Graphs.create_graph(%{name: name, edges: edges, nodes: nodes})
  end
end

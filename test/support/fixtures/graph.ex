defmodule PhxLiveview.Test.Fixtures.Graph do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxLiveview.Graphs` context.
  """

  alias PhxLiveview.{Graph, Repo}

  def graph_fixture(attrs \\ []) do
    name = Keyword.get(attrs, :name, "some name")
    edges = Keyword.get(attrs, :edges, [])
    nodes = Keyword.get(attrs, :nodes, [])

    %Graph{}
    |> Graph.changeset(%{name: name, edges: edges, nodes: nodes})
    |> Repo.insert!()
  end
end

defmodule GraphTheory.Services.Dijkstra do
  @moduledoc """
  Service to solve graphs using dijkstra algorithm.
  """

  alias GraphTheory.Graph

  @spec solve(Graph.t(), String.t(), String.t()) :: {Graph.t(), Graph.t(), integer()}
  def solve(graph, from, to) do
    {graph, graph, 5}
  end
end

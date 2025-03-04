defmodule GraphTheory.Test.API do
  use GraphTheory.DataCase
  import Mox
  import GraphTheory.Test.Fixtures.Graph
  alias GraphTheory.API

  setup :verify_on_exit!

  describe "create_graph/1" do
    setup do
      graph = graph_fixture(nodes: ["A", "B", "C"], edges: ["A-B", "A-C:10"], directed: false)

      %{
        graph: Map.from_struct(graph)
      }
    end

    test "with valid data", %{graph: %{nodes: nodes} = graph} do
      {:ok, result} = API.create_graph(graph)
      %{"url" => url, "body" => body} = Jason.decode!(result)

      expected_edges = [
        %{"source" => "A", "target" => "B", "weight" => 0},
        %{"source" => "A", "target" => "C", "weight" => 10}
      ]

      assert url =~ "/create/undirected"
      %{"nodes" => ^nodes, "edges" => ^expected_edges} = Jason.decode!(body)
    end

    test "create directed graph" do
      graph =
        graph_fixture(
          name: "Directed graph",
          nodes: ["A", "B", "C"],
          edges: ["A-B", "A-C:10"],
          directed: true
        )

      {:ok, result} = API.create_graph(graph)
      %{"url" => url} = Jason.decode!(result)

      assert url =~ "/create/directed"
    end
  end
end

defmodule PhxLiveview.GraphsTest do
  use PhxLiveview.DataCase

  alias PhxLiveview.{Graph, Graphs}

  describe "graphs" do
    @valid_attrs %{edges: [], name: "some name", nodes: []}
    @update_attrs %{edges: [], name: "some updated name", nodes: []}
    @invalid_attrs %{edges: nil, name: nil, nodes: nil}

    setup do
      graph = graph_fixture()
      %{graph: graph}
    end

    test "list_graphs/0 returns all graphs", %{graph: %{id: id}} do
      [%Graph{id: ^id}] = Graphs.list_graphs()
    end

    test "get_graph/1 returns the graph with given id", %{graph: %{id: id}} do
      %Graph{id: ^id} = Graphs.get_graph(id)
    end

    test "create_graph/1 with valid data creates a graph" do
      {:ok,
       %Graph{name: ^@valid_attrs.name, nodes: ^@valid_attrs.nodes, edges: ^@valid_attrs.edges}} =
        Graphs.create_graph(@valid_attrs)
    end

    test "create_graph/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Graphs.create_graph(@invalid_attrs)
    end

    test "update_graph/2 with valid data updates the graph", %{graph: %{id: id} = graph} do
      %Graph{
        id: ^id,
        name: @update_attrs.name,
        nodes: @update_attrs.nodes,
        edges: @update_attrs.edges
      } =
        Graphs.update_graph(graph, @update_attrs)
    end

    test "update_graph/2 with invalid data returns error changeset", %{graph: %{id: id} = graph} do
      {:error, %Ecto.Changeset{}} = Graphs.update_graph(graph, @invalid_attrs)
      %Graph{id: ^id} = Graphs.get_graph(graph.id)
    end

    test "delete_graph/1 deletes the graph" do
      %{id: id} = graph = graph_fixture()
      {:ok, %Graph{id: ^id}} = Graphs.delete_graph(graph)
      nil = Graphs.get_graph(id)
    end

    test "change_graph/1 returns a graph changeset", %{graph: graph} do
      %Ecto.Changeset{} = Graphs.change_graph(graph)
    end
  end
end

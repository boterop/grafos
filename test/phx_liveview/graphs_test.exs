defmodule PhxLiveview.Test.Graphs do
  use PhxLiveview.DataCase
  import PhxLiveview.Test.Fixtures.Graph
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
      %{edges: edges, nodes: nodes} = @valid_attrs
      name = "some other name"

      {:ok, %Graph{name: ^name, nodes: ^nodes, edges: ^edges}} =
        Graphs.create_graph(%{@valid_attrs | name: name})
    end

    test "create_graph/1 with duplicated name", %{graph: %{name: name}} do
      {:error, %Ecto.Changeset{errors: [name: {"has already been taken", _}]}} =
        Graphs.create_graph(%{name: name})
    end

    test "create_graph/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Graphs.create_graph(@invalid_attrs)
    end

    test "update_graph/2 with valid data updates the graph", %{graph: %{id: id} = graph} do
      %{name: name, edges: edges, nodes: nodes} = @update_attrs

      {:ok,
       %Graph{
         id: ^id,
         name: ^name,
         nodes: ^nodes,
         edges: ^edges
       }} =
        Graphs.update_graph(graph, @update_attrs)
    end

    test "update_graph/2 with invalid data returns error changeset", %{graph: %{id: id} = graph} do
      {:error, %Ecto.Changeset{}} = Graphs.update_graph(graph, @invalid_attrs)
      %Graph{id: ^id} = Graphs.get_graph(graph.id)
    end

    test "delete_graph/1 deletes the graph" do
      %{id: id} = graph = graph_fixture(name: "graph to delete")
      {:ok, %Graph{id: ^id}} = Graphs.delete_graph(graph)
      nil = Graphs.get_graph(id)
    end

    test "change_graph/1 returns a graph changeset", %{graph: graph} do
      %Ecto.Changeset{} = Graphs.change_graph(graph)
    end
  end
end

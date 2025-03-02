defmodule PhxLiveviewWeb.Test.Live.CreateGraph do
  use PhxLiveviewWeb.ConnCase
  import Phoenix.LiveViewTest
  import PhxLiveview.Test.Fixtures.Graph
  alias PhxLiveview.Graphs

  @expected_title "crear grafo"
  @expected_subtitle "previsualizar"

  def str_to_list(str) do
    str
    |> String.upcase()
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  setup do
    graph = graph_fixture()
    %{graph: graph}
  end

  test "GET /create-graph renders correctly", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/create-graph")

    assert html =~ @expected_title
    assert html =~ @expected_subtitle
    assert view |> element("#create-graph-submit", "Crear") |> has_element?()

    refute view |> element("#create-graph-submit", "Actualizar") |> has_element?()
  end

  test "GET /create-graph?id set the graph info", %{
    conn: conn,
    graph: %{id: id, name: name, edges: edges, directed: directed}
  } do
    expected_directed_text = "directed"
    expected_undirected_text = "undirected"
    selected_text = "selected=\"selected\""

    graph_directed_value =
      if(directed,
        do: expected_directed_text,
        else: expected_undirected_text
      )

    {:ok, view, html} = live(conn, ~p"/create-graph?id=#{id}")

    assert html =~ name
    assert html =~ Enum.join(edges, ",")
    assert view |> element("#create-graph-submit", "Actualizar") |> has_element?()
    assert html =~ "value=\"#{graph_directed_value}\" #{selected_text}"

    refute view |> element("#create-graph-submit", "Crear") |> has_element?()
  end

  test "Create graph with valid data", %{conn: conn} do
    current_graphs = Graphs.list_graphs()

    {:ok, view, _html} =
      live(conn, ~p"/create-graph")

    %{name: name, nodes: nodes, edges: edges} =
      data = %{
        name: " new graph ",
        nodes: ["A", "B", "C"],
        edges: "a-b,b-c"
      }

    view |> element("#name") |> render_change(data)
    view |> element("#edges") |> render_change(data)

    view |> element("#create-graph-form") |> render_submit()

    new_list = Graphs.list_graphs()

    %{name: created_name, nodes: created_nodes, edges: created_edges, directed: directed} =
      new_list |> List.last()

    assert created_name == name |> String.trim() |> String.capitalize()
    assert created_edges == str_to_list(edges)
    assert directed == false
    assert created_nodes == nodes
    assert length(current_graphs) + 1 == length(new_list)
  end

  test "Update graph with valid data", %{conn: conn, graph: %{id: id}} do
    current_graphs = Graphs.list_graphs()

    {:ok, view, _html} =
      live(conn, ~p"/create-graph?id=#{id}")

    updated_name = "updated graph"
    updated_edges = ["d-e", "e-f"]

    %{name: name, nodes: nodes, edges: edges} =
      data = %{
        name: updated_name,
        nodes: ["D", "E", "F"],
        edges: Enum.join(updated_edges, ",")
      }

    view |> element("#name") |> render_change(data)
    view |> element("#edges") |> render_change(data)

    view |> element("#create-graph-form") |> render_submit()

    %{
      id: updated_id,
      name: updated_name,
      nodes: updated_nodes,
      edges: updated_edges,
      directed: directed
    } =
      Graphs.get_graph(id)

    assert updated_id == id
    assert updated_name == name |> String.trim() |> String.capitalize()
    assert updated_nodes == nodes
    assert updated_edges == str_to_list(edges)
    assert directed == false
    assert length(current_graphs) == length(Graphs.list_graphs())
  end
end

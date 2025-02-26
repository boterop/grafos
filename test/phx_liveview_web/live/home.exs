defmodule PhxLiveviewWeb.Test.Live.PageController do
  use PhxLiveviewWeb.ConnCase
  import PhxLiveview.Test.Fixtures.Graph

  @expected_title "mis grafos"
  @expected_button "crear grafo"

  setup do
    name = "graph to show"
    nodes = ["a", "b", "c"]
    edges = ["a-b", "b-c"]
    graph = graph_fixture(name: name, nodes: nodes, edges: edges)
    %{graph: graph}
  end

  test "GET / renders correctly", %{conn: conn} do
    conn = get(conn, ~p"/")
    response = html_response(conn, 200)

    ^@expected_title =~ response
    ^@expected_button =~ response
  end

  test "GET / shows graphs", %{conn: conn, graph: %{name: name, nodes: nodes, edges: edges}} do
    expected_node_info = "nodos: #{length(nodes)}"
    expected_edge_info = "aristas: #{length(edges)}"

    conn = get(conn, ~p"/")
    response = html_response(conn, 200)

    ^name =~ response
    ^expected_node_info =~ response
    ^expected_edge_info =~ response
  end

  test "Edit graph", %{conn: conn, graph: %{name: name}} do
    {:ok, view, html} = live(conn, ~p"/")
    ^@expected_title =~ html

    view
    |> element("#edit-graph-#{id}")
    |> render_click()

    refute html =~ @expected_title
    ^name =~ html
  end

  test "Create graph button", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/")
    ^@expected_title =~ html

    view
    |> element("button")
    |> render_click()

    refute html =~ @expected_title
  end

  test "Deletes a graph", %{conn: conn, graph: %{name: name}} do
    {:ok, view, html} = live(conn, ~p"/")

    ^name =~ html

    view
    |> element("#delete-#{id}")
    |> render_click()

    refute html =~ name
  end
end

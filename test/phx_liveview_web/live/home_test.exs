defmodule PhxLiveviewWeb.Test.Live.Home do
  use PhxLiveviewWeb.ConnCase
  import Phoenix.LiveViewTest
  import PhxLiveview.Test.Fixtures.Graph

  @expected_title "mis grafos"
  @expected_button "crear grafo"

  def span(text), do: "<span class=\"font-bold\">#{text}</span>"

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

    assert response =~ @expected_title
    assert response =~ @expected_button
  end

  test "GET / shows graphs", %{conn: conn, graph: %{name: name, nodes: nodes, edges: edges}} do
    expected_node_info = "Nodos: #{nodes |> length() |> span()}"
    expected_edge_info = "Aristas: #{edges |> length() |> span()}"

    conn = get(conn, ~p"/")
    response = html_response(conn, 200)

    assert response =~ name
    assert response =~ expected_node_info
    assert response =~ expected_edge_info
  end

  test "Edit graph", %{conn: conn, graph: %{id: id}} do
    expected_url = "/create-graph?id=#{id}"
    {:ok, view, _html} = live(conn, ~p"/")

    {:error, {:redirect, %{to: ^expected_url}}} =
      view
      |> element("#edit-graph-#{id}")
      |> render_click()
  end

  test "Create graph button", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    {:error, {:redirect, %{to: "/create-graph"}}} =
      view
      |> element("#create-graph")
      |> render_click()
  end

  test "Deletes a graph", %{conn: conn, graph: %{id: id, name: name}} do
    {:ok, view, _html} = live(conn, ~p"/")

    view
    |> element("#delete-#{id}")
    |> render_click()

    {:ok, _view, html} = live(conn, ~p"/")
    refute html =~ name
  end
end

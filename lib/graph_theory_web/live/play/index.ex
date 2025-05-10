defmodule GraphTheoryWeb.Live.Play.Index do
  @moduledoc """
    Play LiveView
  """

  use GraphTheoryWeb, :live_view
  alias GraphTheory.{API, Graph, Graphs}
  alias GraphTheory.Services.Dijkstra

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    current_date = Date.utc_today()

    socket =
      id
      |> Graphs.get_graph()
      |> case do
        %Graph{} = graph ->
          socket
          |> assign(:graph, graph)
          |> assign(:from, graph.nodes |> Enum.at(0))
          |> assign(:to, graph.nodes |> Enum.at(0))

        _error ->
          socket |> redirect_home()
      end
      |> assign(:date, current_date)
      |> assign(:min_date, current_date)
      |> assign(:graph_img, nil)
      |> assign(:tagged_graph_img, nil)
      |> assign(:total, nil)

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket), do: redirect_home(socket)

  @impl true
  def handle_event("update_from", %{"from" => from}, socket) do
    {:noreply, socket |> assign(:from, from) |> assign(:total, nil)}
  end

  @impl true
  def handle_event("update_to", %{"to" => to}, socket) do
    {:noreply, socket |> assign(:to, to) |> assign(:total, nil)}
  end

  @impl true
  def handle_event("update_date", %{"date" => date}, socket) do
    {:noreply, assign(socket, :date, date)}
  end

  @impl true
  def handle_event(
        "play",
        %{"from" => from, "to" => to, "date" => date},
        %{assigns: %{graph: graph}} = socket
      ) do
    img =
      graph
      |> API.create_graph()
      |> case do
        {:ok, body} -> "data:image/png;base64,#{Base.encode64(body)}"
        _ -> nil
      end

    {tagged_graph, result_graph, total} =
      graph
      |> apply_discounts(date)
      |> Dijkstra.solve(from, to)
      |> IO.inspect(label: "Dijkstra Result")
      |> case do
        {%Graph{} = tags, %Graph{} = result, total} -> {tags, result, total}
        _ -> {%{}, %{}, 0}
      end

    tagged_graph_img =
      tagged_graph
      |> API.create_graph()
      |> case do
        {:ok, body} -> "data:image/png;base64,#{Base.encode64(body)}"
        _ -> nil
      end

    result_graph_img =
      result_graph
      |> API.create_graph()
      |> case do
        {:ok, body} -> "data:image/png;base64,#{Base.encode64(body)}"
        _ -> nil
      end

    socket
    |> assign(:graph_img, img)
    |> assign(:tagged_graph_img, tagged_graph_img)
    |> assign(:result_graph_img, result_graph_img)
    |> assign(:total, total)
    |> (&{:noreply, &1}).()
  end

  defp redirect_home(socket), do: push_navigate(socket, to: "/")

  defp apply_discounts(graph, date) do
    discounts = %{"7" => %{"LIMA-CUSCO" => 1.5}}

    with {:ok, %{year: year, month: month, day: day}} <- Date.from_iso8601(date),
         day_of_week when is_number(day_of_week) <- :calendar.day_of_the_week(year, month, day),
         discount when is_map(discount) <- discounts[to_string(day_of_week)] do
      discounted_edges =
        graph.edges
        |> Enum.map(fn edge ->
          parts = String.split(edge, ":")
          edge_name = parts |> Enum.at(0) |> String.trim()
          edge_value = parts |> Enum.at(1) |> String.trim() |> String.to_integer()
          discount_value = Map.get(discount, edge_name, 1)
          total = edge_value |> Kernel./(discount_value) |> trunc()
          "#{edge_name}:#{total}"
        end)

      Map.put(graph, :edges, discounted_edges)
    else
      _ -> graph
    end
  end
end

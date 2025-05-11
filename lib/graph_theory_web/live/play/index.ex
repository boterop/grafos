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
      |> assign(:result, nil)

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket), do: redirect_home(socket)

  @impl true
  def handle_event("update_from", %{"from" => from}, socket) do
    {:noreply, socket |> assign(:from, from) |> assign(:result, nil)}
  end

  @impl true
  def handle_event("update_to", %{"to" => to}, socket) do
    {:noreply, socket |> assign(:to, to) |> assign(:result, nil)}
  end

  @impl true
  def handle_event("update_date", %{"date" => date}, socket) do
    {:noreply, socket |> assign(:date, date) |> assign(:result, nil)}
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

    {result_graph, total} =
      graph
      |> apply_discounts(date)
      |> Dijkstra.solve(from, to)
      |> case do
        {%Graph{} = result, total} -> {result, total}
        _ -> {%{}, 0}
      end

    result_graph_img =
      result_graph
      |> API.create_graph()
      |> case do
        {:ok, body} -> "data:image/png;base64,#{Base.encode64(body)}"
        _ -> nil
      end

    result = %{
      graph_img: img,
      result_graph_img: result_graph_img,
      total: total
    }

    {:noreply, assign(socket, :result, result)}
  end

  defp redirect_home(socket), do: push_navigate(socket, to: "/")

  @spec apply_discounts(Graph.t(), String.t()) :: Graph.t()
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

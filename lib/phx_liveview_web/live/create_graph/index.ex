defmodule PhxLiveviewWeb.Live.CreateGraph.Index do
  @moduledoc """
    CreateGraph LiveView
  """

  use PhxLiveviewWeb, :live_view
  alias PhxLiveview.{Graph, Graphs}

  @impl true
  def mount(params, _session, socket) do
    graph =
      with %{"id" => id} <- params,
           %Graph{} = saved_graph <- Graphs.get_graph(id) do
        saved_graph
      else
        _ -> %Graph{}
      end

    {:ok,
     socket
     |> assign(original_graph: graph)
     |> assign(graph: Map.from_struct(graph))
     |> assign(error: nil)}
  end

  @impl true
  def handle_event("update_name", %{"name" => name}, socket) do
    formatted_name = name |> String.trim() |> String.downcase()
    {:noreply, assign(socket, graph: %{socket.assigns.graph | name: formatted_name})}
  end

  @impl true
  def handle_event("update_nodes", %{"nodes" => nodes}, socket) do
    nodes_list = str_to_list(nodes)

    {:noreply, assign(socket, graph: %{socket.assigns.graph | nodes: nodes_list})}
  end

  @impl true
  def handle_event("update_edges", %{"edges" => edges}, socket) do
    edges_list = str_to_list(edges)
    {:noreply, assign(socket, graph: %{socket.assigns.graph | edges: edges_list})}
  end

  @impl true
  def handle_event("toggle_directed", %{"type" => value}, socket) do
    {:noreply, assign(socket, graph: %{socket.assigns.graph | directed: value == "directed"})}
  end

  @impl true
  def handle_event(
        "create",
        _,
        %{assigns: %{graph: graph, original_graph: original_graph}} = socket
      ) do
    case create_update(graph, original_graph) do
      {:ok, _} ->
        {:noreply, push_navigate(socket, to: "/")}

      {:error, changeset} ->
        [{key, {message, _}} | _rest] = changeset.errors
        {:noreply, assign(socket, error: "#{key} #{message}")}
    end
  end

  @spec str_to_list(String.t()) :: list(String.t())
  def str_to_list(str) do
    str
    |> String.trim()
    |> String.upcase()
    |> String.split(",")
  catch
    _ -> []
  end

  @spec create_update(map(), Graph.t()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  defp create_update(%{id: nil} = new_graph, _), do: Graphs.create_graph(new_graph)
  defp create_update(%{} = attrs, original_graph), do: Graphs.update_graph(original_graph, attrs)
end

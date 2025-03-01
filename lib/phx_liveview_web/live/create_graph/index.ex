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

    data = Map.from_struct(graph)
    img = update_preview(data)

    {:ok,
     socket
     |> assign(original_graph: graph)
     |> assign(graph: data)
     |> assign(graph_img: img)
     |> assign(error: nil)}
  end

  @impl true
  def handle_event("update_name", %{"name" => name}, socket) do
    formatted_name = name |> String.trim() |> String.capitalize()
    {:noreply, assign(socket, graph: %{socket.assigns.graph | name: formatted_name})}
  end

  @impl true
  def handle_event("update_edges", %{"edges" => edges}, socket) do
    nodes_list =
      edges
      |> String.split(",")
      |> Enum.map(&get_nodes_from_edge/1)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.filter(&(&1 != ""))

    edges_list = str_to_list(edges)
    new_graph = %{socket.assigns.graph | edges: edges_list}
    new_graph = %{new_graph | nodes: nodes_list}
    {:noreply, assign(socket, graph: new_graph, graph_img: update_preview(new_graph))}
  end

  @impl true
  def handle_event("toggle_directed", %{"type" => value}, socket) do
    new_graph = %{socket.assigns.graph | directed: value == "directed"}
    {:noreply, assign(socket, graph: new_graph, graph_img: update_preview(new_graph))}
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

  def get_nodes_from_edge(edge) do
    [source | [target]] = String.split(edge, "-")

    source =
      source
      |> String.trim()
      |> String.upcase()

    target =
      target
      |> String.split(":")
      |> List.first()
      |> String.trim()
      |> String.upcase()

    [source, target]
  end

  @spec update_preview(map()) :: String.t() | nil
  def update_preview(graph) do
    request_body =
      %{
        nodes: graph.nodes,
        edges: graph.edges |> Enum.map(&format_edge/1),
        node_color: "#f97316"
      }
      |> Jason.encode!()

    type = if graph.directed, do: "directed", else: "undirected"

    image =
      case HTTPoison.post(
             "#{System.get_env("API_URL")}/create/#{type}",
             request_body,
             %{
               "Content-Type" => "application/json"
             }
           ) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body

        _ ->
          nil
      end

    if image, do: "data:image/png;base64,#{Base.encode64(image)}", else: nil
  rescue
    _ -> nil
  end

  @spec format_edge(String.t()) :: map()
  def format_edge(edge) do
    [source | rest] = String.split(edge, "-")
    [target | weight] = rest |> Enum.join("") |> String.trim() |> String.split(":")

    %{source: source, target: target, weight: format_weight(weight)}
  end

  @spec format_weight(list(String.t())) :: number()
  def format_weight([]), do: 0
  def format_weight([weight | _]), do: String.to_integer(weight)

  @spec str_to_list(String.t()) :: list(String.t())
  def str_to_list(str) do
    str
    |> String.upcase()
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(&1 != ""))
  catch
    _ -> []
  end

  @spec create_update(map(), Graph.t()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  defp create_update(%{id: nil} = new_graph, _), do: Graphs.create_graph(new_graph)
  defp create_update(%{} = attrs, original_graph), do: Graphs.update_graph(original_graph, attrs)
end

defmodule PhxLiveviewWeb.Live.CreateGraph.Index do
  @moduledoc """
    CreateGraph LiveView
  """

  use PhxLiveviewWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, graph: %{name: "", nodes: [], edges: [], directed: false})}
  end

  @impl true
  def handle_event("update_name", %{"name" => name}, socket) do
    {:noreply, assign(socket, graph: %{socket.assigns.graph | name: name})}
  end

  @impl true
  def handle_event("update_nodes", %{"nodes" => nodes}, socket) do
    nodes_list =
      try do
        nodes
        |> String.trim()
        |> String.upcase()
        |> String.split(",")
      rescue
        _ -> []
      end

    {:noreply, assign(socket, graph: %{socket.assigns.graph | nodes: nodes_list})}
  end

  @impl true
  def handle_event("toggle_directed", %{"type" => value}, socket) do
    IO.inspect(value)
    {:noreply, assign(socket, graph: %{socket.assigns.graph | directed: value == "directed"})}
  end

  @impl true
  def handle_event("register", _, socket) do
    {:noreply, push_navigate(socket, to: "/register")}
  end
end

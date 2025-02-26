defmodule PhxLiveviewWeb.Live.Home.Index do
  @moduledoc """
    Home LiveView
  """

  use PhxLiveviewWeb, :live_view
  import PhxLiveviewWeb.Card
  alias PhxLiveview.{Graph, Graphs}

  def list_graphs(), do: Graphs.list_graphs() |> Enum.sort_by(& &1.id, :desc)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, graphs: list_graphs())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    with %Graph{} = graph <- Graphs.get_graph(id),
         {:ok, _graph} <- Graphs.delete_graph(graph) do
      {:noreply, assign(socket, graphs: list_graphs())}
    else
      {:error, changeset} ->
        [{key, {message, _}} | _rest] = changeset.errors
        {:noreply, assign(socket, error: "#{key} #{message}")}
    end
  end
end

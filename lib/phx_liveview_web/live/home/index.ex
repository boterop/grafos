defmodule PhxLiveviewWeb.Live.Home.Index do
  @moduledoc """
    Home LiveView
  """

  use PhxLiveviewWeb, :live_view
  import PhxLiveviewWeb.Card
  alias PhxLiveview.Graphs

  @impl true
  def mount(_params, _session, socket) do
    graphs = Graphs.list_graphs() |> Enum.sort_by(& &1.id, :desc)
    {:ok, assign(socket, graphs: graphs)}
  end
end

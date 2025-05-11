defmodule GraphTheoryWeb.Card do
  @moduledoc """
  Renders a card component.

  The card component can be used to display information.

  ## Examples

      <.card>
        This is a card
      </.card>

  """
  use Phoenix.Component

  attr :graph, :map, required: true

  def card(assigns) do
    ~H"""
    <div class="relative aspect-w-1 ">
      <button
        id={"delete-#{@graph.id}"}
        phx-click="delete"
        phx-value-id={@graph.id}
        type="button"
        class="absolute -right-2 -top-2 rounded-full bg-white p-2 shadow-lg brightness-100 hover:brightness-50 transition-all duration-300 ease-in-out"
      >
        <img src="/images/trash.svg" class="w-6" />
      </button>
      <a
        id={"edit-graph-#{@graph.id}"}
        href={"/create-graph?id=#{@graph.id}"}
        class="flex flex-col gap-2 p-6 shadow-lg hover:shadow-xl rounded-lg border border-zinc-100 bg-white"
      >
        <h3 class="flex items-center justify-between text-lg font-semibold leading-6 text-zinc-900 capitalize">
          {@graph.name}
        </h3>
        <span class="text-sm text-center text-nowrap text-zinc-500">
          {if @graph.directed do
            "dirigido"
          else
            "no dirigido"
          end}
        </span>
        <article class="flex justify-between">
          <span>Nodos: <span class="font-bold">{Enum.count(@graph.nodes)}</span></span>
          <span>Aristas: <span class="font-bold">{Enum.count(@graph.edges)}</span></span>
        </article>
      </a>
      <a
        id={"play-#{@graph.id}"}
        href={"/play/#{@graph.id}"}
        type="button"
        class="absolute -right-2 -bottom-2 rounded-full bg-white p-2 shadow-lg brightness-100 hover:brightness-50 transition-all duration-300 ease-in-out"
      >
        <span class="hero-play w-6 text-green-500" />
      </a>
    </div>
    """
  end
end

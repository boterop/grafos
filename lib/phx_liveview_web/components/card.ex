defmodule PhxLiveviewWeb.Card do
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
    <a
      href={"/create-graph?id=#{@graph.id}"}
      class="aspect-w-1 rounded-lg border border-zinc-100 bg-white shadow-lg hover:shadow-xl"
    >
      <div class="flex flex-col gap-4 p-6">
        <h3 class="flex items-center justify-between text-lg font-semibold leading-6 text-zinc-900 capitalize">
          {@graph.name}
          <span class="text-sm text-zinc-500">
            {if @graph.directed do
              "dirigido"
            else
              "no dirigido"
            end}
          </span>
        </h3>

        <article class="flex gap-4">
          <span>Nodos: <span class="font-bold">{Enum.count(@graph.nodes)}</span></span>
          <span>Aristas: <span class="font-bold">{Enum.count(@graph.edges)}</span></span>
        </article>
      </div>
      <div class="flex items-center justify-end">
        <button type="button" class="flex p-6 pt-0">
          <img src="/images/trash.svg" class="w-6" />
        </button>
      </div>
    </a>
    """
  end
end

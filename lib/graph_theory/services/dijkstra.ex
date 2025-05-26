defmodule GraphTheory.Services.Dijkstra do
  @moduledoc """
  Service to solve graphs using dijkstra algorithm.
  """

  @spec solve(map(), String.t(), String.t()) :: {map(), integer()}
  def solve(graph, from, to) do
    tags =
      graph.edges
      |> Enum.map(fn edge ->
        parts = String.split(edge, ":")
        nodes = parts |> Enum.at(0) |> String.trim() |> String.split("-")

        from = nodes |> Enum.at(0) |> String.trim()
        to = nodes |> Enum.at(1) |> String.trim()
        value = parts |> Enum.at(1) |> String.trim() |> String.to_integer()

        %{from: from, to: to, value: value}
      end)
      |> dijkstra(from)

    result_edges =
      tags
      |> Enum.filter(fn %{from: from} -> from != nil end)
      |> Enum.map(fn %{from: from, to: to, value: value} ->
        "#{from}-#{to}:#{value}"
      end)

    cost =
      tags
      |> Enum.filter(fn %{to: current} -> current == to end)
      |> Enum.at(0)
      |> case do
        cost when is_map(cost) ->
          cost

        _ ->
          %{value: 0}
      end

    result_graph = graph |> Map.put(:edges, result_edges)

    {result_graph, cost.value}
  end

  defp dijkstra(edges, prev, original \\ %{}, tags \\ [], acc \\ 0, recalculating? \\ false)

  defp dijkstra(edges, prev, %{}, tags, acc, recalculating?),
    do: dijkstra(edges, prev, edges, tags, acc, recalculating?)

  defp dijkstra(edges, prev, original, [], 0, recalculating?),
    do: dijkstra(edges, prev, original, [%{from: nil, to: prev, value: 0}], 0, recalculating?)

  defp dijkstra([], _prev, _original, tags, _acc, _), do: tags

  defp dijkstra(
         [%{from: from, to: to, value: value} | rest],
         prev,
         original,
         tags,
         acc,
         recalculating?
       ) do
    exist_same_tag? =
      Enum.any?(tags, fn tag -> tag.from == from and tag.to == to end) and !recalculating?

    if from !== prev or exist_same_tag? do
      dijkstra(rest, prev, original, tags, acc, recalculating?)
    else
      total_value = value + acc

      new_tag = %{from: from, to: to, value: total_value}
      existing_tag = Enum.find(tags, fn tag -> tag.to == to end)

      final_tags =
        case existing_tag do
          tag when is_map(tag) ->
            tag
            |> min_value(new_tag)
            |> swap_if_value_changes(tags, tag)
            |> recalculate(new_tag, original)

          _ ->
            tags ++ [new_tag]
        end

      tag = final_tags |> Enum.find(fn tag -> tag.to == to end)
      total_value = tag.value

      next_node_tags =
        dijkstra(rest, prev, original, final_tags, acc, recalculating?)

      dijkstra(
        original,
        to,
        original,
        next_node_tags,
        total_value
      )
    end
  end

  @spec recalculate({boolean(), list()}, map(), list()) :: list()
  defp recalculate({false, tags}, _new_tag, _original), do: tags

  defp recalculate({true, tags}, %{to: prev, value: val}, original) do
    dijkstra(original, prev, original, tags, val, true)
  end

  @spec min_value(map(), map()) :: map()
  defp min_value(%{value: val1} = g1, %{value: val2}) when val1 < val2, do: g1
  defp min_value(_g1, g2), do: g2

  @spec swap_if_value_changes(map(), list(), map()) :: {boolean(), list()}
  defp swap_if_value_changes(%{value: val1} = min_tag, tags, %{value: val2})
       when val1 < val2 do
    tags
    |> Enum.map(fn tag ->
      if tag.to == min_tag.to do
        tag |> Map.put(:value, min_tag.value) |> Map.put(:from, min_tag.from)
      else
        tag
      end
    end)
    |> (&{true, &1}).()
  end

  defp swap_if_value_changes(_, tags, _), do: {false, tags}
end

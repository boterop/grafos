defmodule GraphTheory.API do
  @moduledoc """
  API requests
  """

  @typep graph :: %{nodes: list(), edges: list(), directed: boolean()}
  @typep reason :: atom()
  @typep type :: :directed | :undirected

  @spec create_graph(graph()) :: {:ok, any()} | {:error, reason()}
  def create_graph(graph) do
    request_body = create_graph_request(graph)
    type = get_graph_type(graph)
    url = "#{System.get_env("API_URL")}/create/#{type}"

    case post(url, request_body) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:error, reason} -> {:error, reason}
      _ -> {:error, :unknown}
    end
  end

  @spec create_graph_request(graph()) :: map()
  defp create_graph_request(%{nodes: nodes, edges: edges}) do
    %{
      nodes: nodes,
      edges: edges |> Enum.map(&format_edge/1),
      node_color: "#f97316"
    }
  end

  defp create_graph_request(_), do: %{}

  @spec get_graph_type(map()) :: type()
  defp get_graph_type(%{directed: directed}) when directed, do: :directed
  defp get_graph_type(_), do: :undirected

  @spec post(url :: String.t(), body :: map()) :: {:ok, map()} | {:error, reason()}
  defp post(url, body) do
    http_client().post(
      url,
      Jason.encode!(body),
      %{
        "Content-Type" => "application/json"
      }
    )
  end

  @spec format_edge(String.t()) :: map()
  defp format_edge(edge) do
    [source | rest] = String.split(edge, "-")
    [target | weight] = rest |> Enum.join("") |> String.trim() |> String.split(":")

    %{source: source, target: target, weight: format_weight(weight)}
  end

  @spec format_weight(list(String.t())) :: number()
  defp format_weight([]), do: 0
  defp format_weight([weight | _]), do: String.to_integer(weight)

  @spec http_client :: module()
  defp http_client do
    :graph_theory
    |> Application.get_env(:api)
    |> Keyword.get(:http_client, HTTPoison)
  end
end

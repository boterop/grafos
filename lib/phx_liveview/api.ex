defmodule PhxLiveview.API do
  @moduledoc """
  API requests
  """

  @type graph :: %{nodes: list(), edges: list(), directed: boolean()}
  @type reason :: atom()
  @type type :: :directed | :undirected

  @spec create_graph(graph()) :: {:ok, binary()} | {:error, reason()}
  def create_graph(graph) do
    with request_body <- create_graph_request(graph),
         type <- get_graph_type(graph),
         url <- create_url(type),
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- post(url, request_body) do
      {:ok, body}
    end
  end

  @spec create_graph_request(%{nodes: list(), edges: list()}) :: map()
  defp create_graph_request(%{nodes: nodes, edges: edges}) do
    %{
      nodes: nodes,
      edges: edges |> Enum.map(&format_edge/1),
      node_color: "#f97316"
    }
  end

  defp create_graph_request(_), do: %{}

  @spec get_graph_type(%{directed: boolean()}) :: type()
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

  @spec create_url(type()) :: String.t()
  defp create_url(type), do: "#{System.get_env("API_URL")}/create/#{type}"

  @spec http_client :: module()
  defp http_client do
    :phx_liveview
    |> Application.get_env(:api)
    |> Keyword.get(:http_client, HTTPoison)
  end
end

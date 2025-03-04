defmodule GraphTheory.Graphs do
  @moduledoc """
  The Graphs context.
  """

  import Ecto.Query, warn: false
  alias GraphTheory.Repo

  alias GraphTheory.Graph

  @doc """
  Returns the list of graphs.

  ## Examples

      iex> list_graphs()
      [%Graph{}, ...]

  """
  def list_graphs do
    Repo.all(Graph)
  end

  @doc """
  Gets a single graph.

  Raises `Ecto.NoResultsError` if the Graph does not exist.

  ## Examples

      iex> get_graph(123)
      %Graph{}

      iex> get_graph(456)
      ** (Ecto.NoResultsError)

  """
  def get_graph(id), do: Repo.get(Graph, id)

  @doc """
  Creates a graph.

  ## Examples

      iex> create_graph(%{field: value})
      {:ok, %Graph{}}

      iex> create_graph(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_graph(attrs \\ %{}) do
    %Graph{}
    |> Graph.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a graph.

  ## Examples

      iex> update_graph(graph, %{field: new_value})
      {:ok, %Graph{}}

      iex> update_graph(graph, %{field: bad_value})
      {:error, %Ecto.Changeset{}}}
      iex> update_graph(graph, %{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_graph(%Graph{} = graph, attrs) do
    graph
    |> Graph.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a graph.

  ## Examples

      iex> delete_graph(graph)
      {:ok, %Graph{}}

      iex> delete_graph(graph)
      {:error, %Ecto.Changeset{}}

  """
  def delete_graph(%Graph{} = graph) do
    Repo.delete(graph)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking graph changes.

  ## Examples

      iex> change_graph(graph)
      %Ecto.Changeset{data: %Graph{}}

  """
  def change_graph(%Graph{} = graph, attrs \\ %{}) do
    Graph.changeset(graph, attrs)
  end
end

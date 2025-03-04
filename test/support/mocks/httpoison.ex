defmodule GraphTheory.Mocks.HTTPoison do
  @moduledoc """
  Mock for HTTPoison
  """

  def post(url, body, headers, _opts \\ []) do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body:
         Jason.encode!(%{
           url: url,
           body: body,
           headers: headers
         })
     }}
  end
end

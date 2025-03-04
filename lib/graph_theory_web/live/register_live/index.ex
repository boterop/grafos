defmodule GraphTheoryWeb.Live.Register.Index do
  @moduledoc """
    Register LiveView
  """

  use GraphTheoryWeb, :live_view

  alias GraphTheory.{Account, Account.User}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event(
        "register",
        %{
          "email" => email,
          "password" => password,
          "password_confirmation" => password_confirmation
        },
        socket
      ) do
    with true <- password == password_confirmation,
         %User{id: id} <- Account.create_user(%{email: email, password: password}),
         token <- Phoenix.Token.sign(socket, System.get_env("JWT_SECRET"), id) do
      new_socket =
        socket
        |> assign(:current_user, token)
        |> push_navigate(to: "/")

      {:noreply, new_socket}
    else
      error ->
        {:noreply, assign(socket, error: error)}
    end
  end

  @impl true
  def handle_event("login", _, socket) do
    {:noreply, push_navigate(socket, to: "/login")}
  end
end

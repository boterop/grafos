defmodule GraphTheoryWeb.Live.Login.Index do
  @moduledoc """
    Login LiveView
  """

  use GraphTheoryWeb, :live_view

  alias GraphTheory.Account

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    with %{id: id, password: hash} <- Account.get_user_by_email!(email),
         true <- Bcrypt.verify_pass(password, hash),
         token <- Phoenix.Token.sign(GraphTheoryWeb.Endpoint, System.get_env("JWT_SECRET"), id) do
      new_socket =
        socket
        |> assign(:current_user, token)
        |> push_navigate(to: "/")

      {:noreply, new_socket}
    else
      _ ->
        {:noreply, assign(socket, error: "Invalid email or password")}
    end
  end

  @impl true
  def handle_event("register", _, socket) do
    {:noreply, push_navigate(socket, to: "/register")}
  end
end

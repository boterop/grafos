defmodule GraphTheoryWeb.Pipeline.Auth do
  @moduledoc """
  Pipeline module for Guardian authentication in the GraphTheoryWeb application.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :graph_theory,
    module: GraphTheoryWeb.Pipeline.Guardian,
    error_handler: GraphTheoryWeb.Pipeline.ErrorHandler

  plug Guardian.Plug.VerifyHeader, header_name: "authentication"
  plug Guardian.Plug.EnsureAuthenticated, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end

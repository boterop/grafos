defmodule GraphTheory.Test.Fixtures.Account do
  @moduledoc """
  This module provides functions to help with testing the Account context.
  """

  alias GraphTheory.{Account.User, Repo}

  def user_fixture(opts \\ []) do
    email = Keyword.get(opts, :email, "some.email@gmail.com")
    password = Keyword.get(opts, :password, "some password")

    %User{}
    |> User.changeset(%{email: email, password: password})
    |> Repo.insert!()
  end
end

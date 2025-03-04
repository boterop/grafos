defmodule GraphTheory.Test.Account do
  use GraphTheory.DataCase

  import GraphTheory.Test.Fixtures.Account

  alias GraphTheory.{Account, Account.User}

  describe "users" do
    @valid_attrs %{email: "some.email1@gmail.com", password: "some password"}
    @update_attrs %{email: "some.updated@gmail.com", password: "some updated password"}
    @invalid_attrs %{email: "invalid email", password: nil}

    setup do
      user = user_fixture()
      %{user: user}
    end

    test "list_users/0 returns all users", %{user: %{id: id}} do
      [%User{id: ^id}] = Account.list_users()
    end

    test "get_user!/1 returns the user with given id", %{user: %{id: id, email: email}} do
      %User{id: ^id, email: ^email} = Account.get_user!(id)
    end

    test "create_user/1 with valid data creates a user" do
      %{email: email, password: password} = @valid_attrs
      {:ok, %User{email: ^email, password: user_password}} = Account.create_user(@valid_attrs)
      Bcrypt.verify_pass(password, user_password)
    end

    test "create_user/1 with duplicated email", %{user: %{email: email}} do
      {:error, %Ecto.Changeset{errors: [email: {"has already been taken", _}]}} =
        @valid_attrs |> Map.put(:email, email) |> Account.create_user()
    end

    test "create_user/1 with invalid data returns error changeset" do
      {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user", %{user: user} do
      %{email: updated_email} = @update_attrs
      {:ok, %User{} = updated_user} = Account.update_user(user, @update_attrs)
      %{email: ^updated_email} = updated_user
    end

    test "update_user/2 with invalid data returns error changeset", %{
      user: %{email: email, password: password} = user
    } do
      {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      %{email: ^email, password: ^password} = Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user", %{user: user} do
      {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      %Ecto.Changeset{} = Account.change_user(user, @valid_attrs)
    end
  end
end

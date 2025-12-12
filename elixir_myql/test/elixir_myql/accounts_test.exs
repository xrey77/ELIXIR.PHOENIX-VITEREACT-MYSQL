defmodule ElixirMyql.AccountsTest do
  use ElixirMyql.DataCase

  alias ElixirMyql.Accounts

  describe "users" do
    alias ElixirMyql.Accounts.User

    import ElixirMyql.AccountsFixtures

    @invalid_attrs %{mobile: nil, username: nil, password: nil, firstname: nil, lastname: nil, email: nil, roles: nil, isactivated: nil, isblocked: nil, mailtoken: nil, userpic: nil, secret: nil, qrcodeurl: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{mobile: "some mobile", username: "some username", password: "some password", firstname: "some fistname", lastname: "some lastname", email: "some email", roles: "some roles", isactivated: 42, isblocked: 42, mailtoken: 42, userpic: "some userpic", secret: "some secret", qrcodeurl: "some qrcodeurl"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.mobile == "some mobile"
      assert user.username == "some username"
      assert user.password == "some password"
      assert user.firstname == "some firstname"
      assert user.lastname == "some lastname"
      assert user.email == "some email"
      assert user.roles == "some roles"
      assert user.isactivated == 42
      assert user.isblocked == 42
      assert user.mailtoken == 42
      assert user.userpic == "some userpic"
      assert user.secret == "some secret"
      assert user.qrcodeurl == "some qrcodeurl"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{mobile: "some updated mobile", username: "some updated username", password: "some updated password", fistname: "some updated fistname", lastname: "some updated lastname", email: "some updated email", roles: "some updated roles", isactivated: 43, isblocked: 43, mailtoken: 43, userpic: "some updated userpic", secret: "some updated secret", qrcodeurl: "some updated qrcodeurl"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.mobile == "some updated mobile"
      assert user.username == "some updated username"
      assert user.password == "some updated password"
      assert user.firstname == "some updated firstname"
      assert user.lastname == "some updated lastname"
      assert user.email == "some updated email"
      assert user.roles == "some updated roles"
      assert user.isactivated == 43
      assert user.isblocked == 43
      assert user.mailtoken == 43
      assert user.userpic == "some updated userpic"
      assert user.secret == "some updated secret"
      assert user.qrcodeurl == "some updated qrcodeurl"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

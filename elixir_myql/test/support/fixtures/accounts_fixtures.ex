defmodule ElixirMyql.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirMyql.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        fistname: "some fistname",
        isactivated: 42,
        isblocked: 42,
        lastname: "some lastname",
        mailtoken: 42,
        mobile: "some mobile",
        password: "some password",
        qrcodeurl: "some qrcodeurl",
        roles: "some roles",
        secret: "some secret",
        username: "some username",
        userpic: "some userpic"
      })
      |> ElixirMyql.Accounts.create_user()

    user
  end
end

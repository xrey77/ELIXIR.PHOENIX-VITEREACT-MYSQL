defmodule ElixirMyqlWeb.UserControllerTest do
  use ElixirMyqlWeb.ConnCase

  import ElixirMyql.AccountsFixtures

  alias ElixirMyql.Accounts.User

  @create_attrs %{
    mobile: "some mobile",
    username: "some username",
    password: "some password",
    fistname: "some fistname",
    lastname: "some lastname",
    email: "some email",
    roles: "some roles",
    isactivated: 42,
    isblocked: 42,
    mailtoken: 42,
    userpic: "some userpic",
    secret: "some secret",
    qrcodeurl: "some qrcodeurl"
  }
  @update_attrs %{
    mobile: "some updated mobile",
    username: "some updated username",
    password: "some updated password",
    fistname: "some updated fistname",
    lastname: "some updated lastname",
    email: "some updated email",
    roles: "some updated roles",
    isactivated: 43,
    isblocked: 43,
    mailtoken: 43,
    userpic: "some updated userpic",
    secret: "some updated secret",
    qrcodeurl: "some updated qrcodeurl"
  }
  @invalid_attrs %{mobile: nil, username: nil, password: nil, fistname: nil, lastname: nil, email: nil, roles: nil, isactivated: nil, isblocked: nil, mailtoken: nil, userpic: nil, secret: nil, qrcodeurl: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "fistname" => "some fistname",
               "isactivated" => 42,
               "isblocked" => 42,
               "lastname" => "some lastname",
               "mailtoken" => 42,
               "mobile" => "some mobile",
               "password" => "some password",
               "qrcodeurl" => "some qrcodeurl",
               "roles" => "some roles",
               "secret" => "some secret",
               "username" => "some username",
               "userpic" => "some userpic"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "fistname" => "some updated fistname",
               "isactivated" => 43,
               "isblocked" => 43,
               "lastname" => "some updated lastname",
               "mailtoken" => 43,
               "mobile" => "some updated mobile",
               "password" => "some updated password",
               "qrcodeurl" => "some updated qrcodeurl",
               "roles" => "some updated roles",
               "secret" => "some updated secret",
               "username" => "some updated username",
               "userpic" => "some updated userpic"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end

defmodule ElixirMyqlWeb.GetallusersController do
  use ElixirMyqlWeb, :controller

  defp build_users_list(result) do
    columns = Enum.map(result.columns, &String.to_atom/1)

    Enum.map(result.rows, fn row ->
      Enum.zip(columns, row) |> Map.new()
    end)
  end

  def getAllusers_api(conn, _params) do

    query = "SELECT id, firstname, lastname, email, mobile, username, roles, isactivated, isblocked, userpic, qrcodeurl FROM users ORDER BY id"
    case ElixirMyql.Repo.query(query, []) do
      {:ok, result} ->
            users = build_users_list(result)

            if Enum.empty?(users) do

              res = %{ message: "No record(s) found." }
              conn |> put_status(:not_found) |> json(res)

            else

              conn |> put_status(:ok) |> json(users)
          end
        end
    end
end

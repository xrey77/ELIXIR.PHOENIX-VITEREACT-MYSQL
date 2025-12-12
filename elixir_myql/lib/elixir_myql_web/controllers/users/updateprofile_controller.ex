defmodule ElixirMyqlWeb.UpdateprofileController do
  use ElixirMyqlWeb, :controller

  def updateProfile_api(conn,  %{"id" => id} = params) do

    query = "SELECT id, firstname, lastname, email, mobile, username, password, roles, isactivated, isblocked, userpic, qrcodeurl FROM users WHERE id = ?"
    params1 = [id]
    case ElixirMyql.Repo.query(query, params1) do
      {:ok, result} ->

          if Enum.any?(result.rows) do

            first_row = Enum.at(result.rows, 0)
            columns = result.columns
            user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

            id_value = user_map["id"]
            IO.puts(id_value)
            firstname_param = params["firstname"]
            lastname_param = params["lastname"]
            mobile_param = params["mobile"]

            sql = "UPDATE users SET firstname = ?, lastname = ?, mobile = ? WHERE id = ?"
            params2 = [firstname_param, lastname_param, mobile_param, id]
            case ElixirMyql.Repo.query(sql, params2) do
              {:ok, _result} ->

                    response = %{ message: "You have updated your profile successfully." }
                    conn |> put_status(:ok) |> json(response)

              {:error, reason} ->

                    response = %{ message: reason }
                    conn |> put_status(:conflict) |> json(response)
            end

          else
            response = %{ message: "User not found." }
            conn |> put_status(:not_found) |> json(response)
          end

      {:error, reason} ->

        response = %{ message: reason }
        conn |> put_status(:conflict) |> json(response)

    end

  end
end

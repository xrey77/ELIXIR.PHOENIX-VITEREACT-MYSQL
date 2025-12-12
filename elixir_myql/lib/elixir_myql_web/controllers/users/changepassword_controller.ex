defmodule ElixirMyqlWeb.ChangepasswordController do
  use ElixirMyqlWeb, :controller

  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  def changePassword_api(conn,  %{"id" => id} = params) do

    plain_password = params["password"]
    query = "SELECT id, firstname, lastname, email, mobile, username, password, roles, isactivated, isblocked, userpic, qrcodeurl FROM users WHERE id = ?"
    params = [id]
    case ElixirMyql.Repo.query(query, params) do
      {:ok, result} ->

          if Enum.any?(result.rows) do

            first_row = Enum.at(result.rows, 0)
            columns = result.columns
            user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

            id_value = user_map["id"]
            IO.puts(id_value)

            hashedPassword = hash_password(plain_password)

            sql = "UPDATE users SET password = ? WHERE id = ?"
            params = [hashedPassword, id]
            case ElixirMyql.Repo.query(sql, params) do
              {:ok, _result} ->

                    response = %{ message: "You have successfully changed your password." }
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

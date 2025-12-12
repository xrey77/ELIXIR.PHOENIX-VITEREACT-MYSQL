defmodule ElixirMyqlWeb.GetuseridController do
  use ElixirMyqlWeb, :controller

  def getUserid_api(conn, %{"id" => id}) do

    query = "SELECT id, firstname, lastname, email, mobile, username, roles, isactivated, isblocked, userpic, qrcodeurl FROM users WHERE id = ?"
    params = [id]
    case ElixirMyql.Repo.query(query, params) do
      {:ok, result} ->

          if Enum.any?(result.rows) do

            first_row = Enum.at(result.rows, 0)
            columns = result.columns
            user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

            id_value = user_map["id"]
            firstname_value = user_map["firstname"]
            lastname_value = user_map["lastname"]
            email_value = user_map["email"]
            mobile_value = user_map["mobile"]
            username_value = user_map["username"]
            roles_value = user_map["roles"]
            isactivated_value = user_map["isactivated"]
            isblocked_value = user_map["isblocked"]
            userpic_value = user_map["userpic"]
            qrcodeurl_value = user_map["qrcodeurl"]

            res = %{
              message: "User details has been retrieved.",
              id: id_value,
              firstname: firstname_value,
              lastname: lastname_value,
              email: email_value,
              mobile: mobile_value,
              roles: roles_value,
              isactivated: isactivated_value,
              isblocked: isblocked_value,
              userpic: userpic_value,
              qrcodeurl: qrcodeurl_value,
              username: username_value
            }
            conn |> put_status(:ok) |> json(res)
          else
            response = %{ message: "User not found." }
            conn |> put_status(:not_found) |> json(response)

          end

    end

    end
end

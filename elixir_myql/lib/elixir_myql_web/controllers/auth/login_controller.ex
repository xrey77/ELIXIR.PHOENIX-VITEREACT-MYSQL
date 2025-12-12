defmodule ElixirMyqlWeb.LoginController do
  use ElixirMyqlWeb, :controller

  def generate_user_token_encapsulated(email_value) do
    claims = %{"email" => email_value}

    case ElixirMysql.Token.generate_and_sign(claims) do
      {:ok, token, _claims} ->
        {:ok, token}

      {:error, reason} ->
        IO.inspect(reason, label: "Joken Error")
        {:error, reason}
    end
  end

  def signin_api(conn, login_params) do

    username = login_params["username"]
    plain_password = login_params["password"]


    query = "SELECT id, firstname, lastname, email, mobile, username, password, roles, isactivated, isblocked, userpic, qrcodeurl FROM users WHERE username = ?"
    params = [username]
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
            password_value = user_map["password"]
            roles_value = user_map["roles"]
            isactivated_value = user_map["isactivated"]
            isblocked_value = user_map["isblocked"]
            userpic_value = user_map["userpic"]
            qrcodeurl_value = user_map["qrcodeurl"]

            if Bcrypt.verify_pass(plain_password, password_value) do

              with {:ok, token} <- generate_user_token_encapsulated(email_value) do

                res = %{
                  message: "Login Successfull.",
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
                  username: username_value,
                  password: password_value,
                  token: token }
                conn |> put_status(:ok) |> json(res)


              else
                {:error, reason} ->
                  IO.inspect(reason, label: "Token Generation Error")
                  conn
                  |> put_status(:internal_server_error)
                  |> json(%{message: "Login failed."})
              end

            else

              response = %{ message: "Invalid Password, try again." }
              conn |> put_status(:not_found) |> json(response)

            end

          else
            response = %{ message: "User not found, please register." }
            conn |> put_status(:not_found) |> json(response)
          end

      {:error, reason} ->

        response = %{ message: reason }
        conn |> put_status(:conflict) |> json(response)

    end

    end
end

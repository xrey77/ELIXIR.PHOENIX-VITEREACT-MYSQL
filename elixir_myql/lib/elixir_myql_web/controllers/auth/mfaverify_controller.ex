defmodule ElixirMyqlWeb.MfaverifyController do
  use ElixirMyqlWeb, :controller

  def mfaVerify_api(conn, %{"id" => id} = mfa_params) do

    query = "SELECT id, username, secret FROM users WHERE id = ?"
    params = [id]
    case ElixirMyql.Repo.query(query, params) do
      {:ok, result} ->

          if Enum.any?(result.rows) do

            first_row = Enum.at(result.rows, 0)
            columns = result.columns
            user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

            otpcode = mfa_params["otp"]

            id_value = user_map["id"]
            IO.puts(id_value)
            username_value = user_map["username"]
            secret_value = user_map["secret"]
            if is_nil(secret_value) do
              res = %{
                message: "Multi-Factor Authenticator is not yet enabled."}
              conn |> put_status(:ok) |> json(res)
            end

            is_valid = NimbleTOTP.valid?(secret_value, otpcode)
            if is_valid do

              res = %{
                username: username_value,
                message: "TOTP code verified successfully."}
              conn |> put_status(:ok) |> json(res)

            else

              res = %{message: "Invalid TOTP code, please try again."}
              conn |> put_status(:conflict) |> json(res)

            end



          else
            response = %{ message: "User not found, please register." }
            conn |> put_status(:not_found) |> json(response)
          end

    end

    end
end

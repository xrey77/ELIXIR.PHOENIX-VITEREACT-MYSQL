defmodule ElixirMyqlWeb.MfaactivateController do
  use ElixirMyqlWeb, :controller

  def delete_oldfile(file_path) when is_binary(file_path) do
    case File.rm(file_path) do
      :ok ->
          IO.puts("Oldfile delete.")
      {:error, _reason} ->
          IO.puts("Oldfile delete failed.")
    end
  end

  def mfaActivate_api(conn,  %{"id" => id} = params) do

    if params["TwoFactorEnabled"] == true do

      query = "SELECT id, email, qrcodeurl FROM users WHERE id = ?"
      params = [id]
      case ElixirMyql.Repo.query(query, params) do
        {:ok, result} ->

            if Enum.any?(result.rows) do
              first_row = Enum.at(result.rows, 0)
              columns = result.columns
              user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

              id_value = user_map["id"]
              IO.puts(id_value)
              email_value = user_map["email"]

              secret = NimbleTOTP.secret()
              encoded_secret = Base.encode64(secret)
              IO.puts("EMAIL VALUE : " <> email_value)
              otpauth_uri = NimbleTOTP.otpauth_uri(email_value, encoded_secret, issuer: "BARCLAYS BANK  ")

              qr_code_png =
                otpauth_uri
                |> EQRCode.encode()
                |> EQRCode.png()
                qrcode_filename = "00" <> id <> ".png"
                qrcode_path = Path.join(["priv", "static", "qrcodes"])
                destination_path = Path.join(qrcode_path, qrcode_filename)

              File.write(destination_path, qr_code_png, [:binary])

              sql = "UPDATE users SET secret = ?, qrcodeurl = ? WHERE id = ?"
              params = [encoded_secret, qrcode_filename, id]
              case ElixirMyql.Repo.query(sql, params) do
                {:ok, _result} ->

                  res = %{
                    qrcodeurl: qrcode_filename,
                    message: "Multi-Factor Authenticator has been enabled."
                  }
                  conn |> put_status(:ok) |> json(res)

                {:error, reason} ->

                      response = %{ message: reason }
                      conn |> put_status(:conflict) |> json(response)
              end


            else
              response = %{ message: "User not found." }
              conn |> put_status(:not_found) |> json(response)
            end


        end


    else

      query = "SELECT id, qrcodeurl FROM users WHERE id = ?"
      params = [id]
      case ElixirMyql.Repo.query(query, params) do
        {:ok, result} ->

            if Enum.any?(result.rows) do
              first_row = Enum.at(result.rows, 0)
              columns = result.columns
              user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

              id_value = user_map["id"]
              IO.puts(id_value)
              qrcodeurl_value = user_map["qrcodeurl"]


              qrcode_path = Path.join(["priv", "static", "qrcodes"])
              oldQrcode = Path.join(qrcode_path, qrcodeurl_value)

              if File.exists?(oldQrcode) do
                delete_oldfile(oldQrcode)
              else
                IO.puts("File does not exist....")
              end

              sql = "UPDATE users SET secret = null, qrcodeurl = null WHERE id = ?"
              params = [id]
              case ElixirMyql.Repo.query(sql, params) do
                {:ok, _result} ->
                  res = %{
                    message: "Multi-Factor Authenticator has been disabled."
                  }
                  conn |> put_status(:ok) |> json(res)

                {:error, reason} ->

                      response = %{ message: reason }
                      conn |> put_status(:conflict) |> json(response)
              end

            else
              response = %{ message: "User not found." }
              conn |> put_status(:not_found) |> json(response)

            end
      end


    end

    end
end

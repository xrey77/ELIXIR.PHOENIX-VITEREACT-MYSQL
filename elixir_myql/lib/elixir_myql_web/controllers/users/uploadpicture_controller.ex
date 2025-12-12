defmodule ElixirMyqlWeb.UploadpictureController do
  use ElixirMyqlWeb, :controller
  import Plug.Conn

  def delete_oldfile(file_path) when is_binary(file_path) do
    case File.rm(file_path) do
      :ok -> # File.rm returns :ok on success, not {:ok, :ok}
          IO.puts("Oldfile delete.")
      {:error, reason} ->
          IO.inspect(reason, from: "File deletion failed")
          IO.puts("Oldfile delete failed.")
    end
  end

  def uploadPicture_api(conn, %{"id" => id, "userpic" => upload_params}) do
    query = "SELECT id, firstname, lastname, email, mobile, username, userpic FROM users WHERE id = ?"
    params1 = [id]

    case ElixirMyql.Repo.query(query, params1) do
      {:ok, result} ->
        if Enum.any?(result.rows) do
          first_row = Enum.at(result.rows, 0)
          columns = result.columns
          user_map = Enum.zip(columns, first_row) |> Enum.into(%{})

          userpic_value = user_map["userpic"]
          IO.puts(user_map["id"])

          upload_dir = Path.join(["priv", "static", "users"])
          File.mkdir_p!(upload_dir)

          # Delete oldpicture
          oldpicture = Path.join(upload_dir, userpic_value)
          if userpic_value != "pix.png" do
            delete_oldfile(oldpicture)
          end

          # Create new image filename
          extension = Path.extname(upload_params.filename)
          new_filename = "00" <> id <> extension

          destination_filename = Path.basename(new_filename)
          destination_path = Path.join(upload_dir, destination_filename)

          sql = "UPDATE users SET userpic = ? WHERE id = ?"
          params2 = [new_filename, id]
          case ElixirMyql.Repo.query(sql, params2) do
            {:ok, _result} ->
              IO.puts("Success...")
            {:error, reason} ->
              IO.puts("Update error : " <> reason)
          end

          case File.cp(upload_params.path, destination_path) do
            :ok ->
              conn
              |> put_status(:created)
              |> json(%{
                userpic: new_filename,
                message: "You have updated your profile picture successfully"
              })

            {:error, reason} ->
              conn
              |> put_status(:internal_server_error)
              |> json(%{error: "Failed to save image: #{reason}"})
          end

        else
          response = %{message: "User not found."}
          conn |> put_status(:not_found) |> json(response)
        end

      {:error, reason} ->

        response = %{message: reason}
        conn |> put_status(:conflict) |> json(response)

      :ok ->
        conn |> put_status(:no_content) |> json(%{message: "Query successful, but no data returned."})
    end
  end
end

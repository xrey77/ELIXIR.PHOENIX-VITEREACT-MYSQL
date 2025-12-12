defmodule ElixirMyqlWeb.RegisterController do
  use ElixirMyqlWeb, :controller

  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  def signup_api(conn, register_params) do

    plainpassword = register_params["password"]
    hashedpassword = hash_password(plainpassword)

    firstname = register_params["firstname"]
    lastname = register_params["lastname"]
    email = register_params["email"]
    mobile = register_params["mobile"]
    username = register_params["username"]
    password = hashedpassword
    roles = "ROLE_USER"
    isactivated = 1
    isblocked = 0
    mailtoken = 0
    userpic = "pix.png"

    # VALIDATE EMAIL IF EXISTING
    query = "SELECT COUNT(*) as email FROM users WHERE email = ?"
    params = [email]
    case ElixirMyql.Repo.query(query, params) do
      {:ok, %{rows: [[count]]}} ->
              if count > 0 do

                    response = %{message: "Email Address is taken."}
                    conn |> put_status(:ok) |> json(response)

              else
                    # VALIDATE USERNAME IF EXISTING
                    query = "SELECT COUNT(*) as username FROM users WHERE username = ?"
                    params = [username]
                    case ElixirMyql.Repo.query(query, params) do
                      {:ok, %{rows: [[count]]}} ->
                              if count > 0 do
                                    response = %{
                                      message: "Username is already taken."
                                    }
                                    conn
                                    |> put_status(:ok)
                                    |> json(response)
                              else
                                    # IF EMAIL AND USERNAME IS AVAILABLE EXECUTE INSERT
                                    IO.puts("Insert record(s)")
                                    sql = "INSERT INTO users (firstname, lastname, email, mobile, username, password, isactivated, userpic, isblocked, mailtoken, roles) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                                    params = [firstname, lastname, email, mobile, username, password, isactivated, userpic, isblocked, mailtoken, roles]
                                    case ElixirMyql.Repo.query(sql, params) do
                                      {:ok, _result} ->

                                            response = %{ message: "Registration Successfull, please login now." }
                                            conn |> put_status(:ok) |> json(response)

                                      {:error, reason} ->

                                            response = %{ message: reason }
                                            conn |> put_status(:conflict) |> json(response)
                                    end
                              end
                    end

              end

          {:error, reason} ->

                response = %{ message: reason }
                conn |> put_status(:conflict) |> json(response)

          end
    end
end
